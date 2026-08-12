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

    const userClient = createClient(
      supabaseUrl,
      Deno.env.get('SUPABASE_ANON_KEY') ?? serviceRoleKey,
      {
        global: {
          headers: {
            Authorization: authHeader,
          },
        },
      },
    )

    const adminClient = createClient(
      supabaseUrl,
      serviceRoleKey,
    )

    const {
      data: { user },
      error: userError,
    } = await userClient.auth.getUser()

    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized user' }),
        {
          status: 401,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const { data: callerProfile, error: profileError } = await userClient
      .from('profiles')
      .select('organization_id, role')
      .eq('id', user.id)
      .single()

    if (profileError || !callerProfile) {
      return new Response(
        JSON.stringify({ error: 'User profile not found' }),
        {
          status: 403,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    if (callerProfile.role !== 'admin') {
      return new Response(
        JSON.stringify({ error: 'Only admins can send invitations' }),
        {
          status: 403,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const body = await req.json()

    const email = body.email?.toString().trim().toLowerCase()
    const fullName = body.fullName?.toString().trim() ?? ''
    const jobTitle = body.jobTitle?.toString().trim() ?? ''
    const role = body.role?.toString().trim() ?? 'viewer'

    if (!email) {
      return new Response(
        JSON.stringify({ error: 'Email is required' }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const allowedRoles = ['admin', 'hse', 'supervisor', 'viewer']

    if (!allowedRoles.includes(role)) {
      return new Response(
        JSON.stringify({ error: 'Invalid role' }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    const { data: inviteRow, error: inviteRowError } = await adminClient
      .from('team_invites')
      .insert({
        organization_id: callerProfile.organization_id,
        email,
        full_name: fullName,
        job_title: jobTitle,
        role,
        status: 'pending',
        invited_by: user.id,
      })
      .select('id')
      .single()

    if (inviteRowError) {
      return new Response(
        JSON.stringify({ error: inviteRowError.message }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

  const { error: inviteError } =
  await adminClient.auth.admin.inviteUserByEmail(email, {
    redirectTo: 'sentinelhse://login-callback/',
    data: {
      organization_id: callerProfile.organization_id,
      full_name: fullName,
      job_title: jobTitle,
      role: role,
      sentinel_invite: true,
    },
  })

    if (inviteError) {
      await adminClient
        .from('team_invites')
        .delete()
        .eq('id', inviteRow.id)

      return new Response(
        JSON.stringify({ error: inviteError.message }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        },
      )
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: 'Invitation sent successfully',
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