import { createClient } from 'npm:@supabase/supabase-js@2'

Deno.serve(async (req) => {
  try {
    if (req.method !== 'POST') {
      return new Response(
        JSON.stringify({ error: 'Method not allowed' }),
        {
          status: 405,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const authHeader = req.headers.get('Authorization')

    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'Missing authorization header' }),
        {
          status: 401,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

    if (!supabaseUrl || !serviceRoleKey) {
      return new Response(
        JSON.stringify({ error: 'Server configuration is incomplete' }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const token = authHeader.replace('Bearer ', '').trim()

    const adminClient = createClient(
      supabaseUrl,
      serviceRoleKey,
    )

    const {
      data: { user },
      error: userError,
    } = await adminClient.auth.getUser(token)

    if (userError || !user || !user.email) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized user' }),
        {
          status: 401,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const email = user.email.trim().toLowerCase()

    const { data: existingProfile } = await adminClient
      .from('profiles')
      .select('id')
      .eq('id', user.id)
      .maybeSingle()

    if (existingProfile) {
      return new Response(
        JSON.stringify({
          success: true,
          alreadyCompleted: true,
        }),
        {
          status: 200,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const { data: invite, error: inviteError } = await adminClient
      .from('team_invites')
      .select(
        'id, organization_id, email, full_name, job_title, role, status',
      )
      .eq('email', email)
      .eq('status', 'pending')
      .order('created_at', { ascending: false })
      .limit(1)
      .maybeSingle()

    if (inviteError) {
      return new Response(
        JSON.stringify({ error: inviteError.message }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    if (!invite) {
      return new Response(
        JSON.stringify({
          success: false,
          invited: false,
          message: 'No pending Sentinel HSE invitation found.',
        }),
        {
          status: 200,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const allowedRoles = ['admin', 'hse', 'supervisor', 'viewer']

    if (!allowedRoles.includes(invite.role)) {
      return new Response(
        JSON.stringify({ error: 'Invalid invitation role' }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const { error: profileInsertError } = await adminClient
      .from('profiles')
      .insert({
        id: user.id,
        organization_id: invite.organization_id,
        full_name: invite.full_name ?? '',
        email,
        job_title: invite.job_title ?? '',
        role: invite.role,
        is_active: true,
      })

    if (profileInsertError) {
      return new Response(
        JSON.stringify({ error: profileInsertError.message }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const { error: inviteUpdateError } = await adminClient
      .from('team_invites')
      .update({
        status: 'accepted',
        accepted_at: new Date().toISOString(),
      })
      .eq('id', invite.id)

    if (inviteUpdateError) {
      await adminClient
        .from('profiles')
        .delete()
        .eq('id', user.id)

      return new Response(
        JSON.stringify({ error: inviteUpdateError.message }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    return new Response(
      JSON.stringify({
        success: true,
        invited: true,
      }),
      {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      },
    )
  } catch (error) {
    return new Response(
      JSON.stringify({
        error: error instanceof Error
          ? error.message
          : 'Unexpected server error',
      }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      },
    )
  }
})