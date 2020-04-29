import 'package:clicksendflutter/models/sms_history_data.dart';
import 'package:clicksendflutter/models/sms_history_response.dart';
import 'package:clicksendflutter/resources/repository_base.dart';

class SmsRepository extends RepositoryBase {
  Future<SmsHistoryData> fetchSMSHistory({page: int}) async {
    var header = await apiBaseHelper.getOtherHeaders();
    final response = await apiBaseHelper
        .get('/sms/history?order_by=date:desc&page=$page', headers: header);
    SmsHistoryResponse r = SmsHistoryResponse.fromJson(response);
    return r.data as SmsHistoryData;
  }
}
