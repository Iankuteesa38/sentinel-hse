import '../../../core/ai/sentinel_ai_service.dart';
import '../models/toolbox_talk_result.dart';

class ToolboxTalkService {
  const ToolboxTalkService();

  Future<ToolboxTalkResult> generateToolboxTalk({required String topic}) async {
    final result = await SentinelAIService.generateToolboxTalk(topic: topic);

    return ToolboxTalkResult.fromJson(result);
  }
}
