import 'dart:convert';

import 'package:flutter_demo/utils/dio_util.dart';
import 'package:sp_util/sp_util.dart';

class ApiService {
  static DioUtil dio;

  /// 初始化必须调用
  ApiService.initialize() {
    DioUtil.setBaseOptions(DioUtil.getBaseOptions()
        .merge(baseUrl: 'http://103.145.60.199:9527/finaldesign'));
    DioUtil.enableDebug();
    dio = DioUtil();
  }

  /// 登录接口
  static Future<Resp<Map<String, dynamic>>> login({
    String phone,
    String password,
  }) async {
    Resp<Map<String, dynamic>> resp = await dio.post(
      '/user/login/phone',
      data: {'phone': phone, 'password': password},
    );
    bool isSuccess = resp.code == 0;
    if (isSuccess) SpUtil.putString('jwt', resp.data['jwt']['access_token']);
    return resp;
  }

  /// 请求验证码接口
  static Future<Resp<String>> applyVerificationCode(String phone) async {
    Resp<String> resp = await dio.fetch(
      '/user/sms',
      queryParameters: {'phone': phone},
    );
    return resp;
  }

  /// 注册接口
  static Future<Resp<Null>> register({
    String phone,
    String password,
    String verificationCode,
  }) async {
    Resp<Null> resp = await dio.post(
      '/user/register/phone/$verificationCode',
      data: {'phone': phone, 'password': password},
    );
    return resp;
  }

  /// 查询用户信息（用户态）
  static Future<Resp<Map<String, dynamic>>> getUserInfo() async {
    Resp<Map<String, dynamic>> resp = await dio.fetch('/user/info');
    return resp;
  }

  /// 更新用户信息（用户态）
  static Future<Resp<Null>> updateUserInfo({
    String nickname,
    String introduction,
    String peeYear,
    int peeProfession,
    int sex,
  }) async {
    Resp<Null> resp = await dio.put('/user/update', data: {
      'nickname': nickname,
      'introduction': introduction,
      'peeYear': peeYear,
      'peeProfession': peeProfession,
      'sex': sex
    });
    return resp;
  }

  /// b币充值（用户态）
  static Future<Resp<Null>> recharge(int value) async {
    Resp<Null> resp = await dio.put('/user/info/$value');
    return resp;
  }

  /// 瓜子兑换（用户态）
  static Future<Resp<Null>> exchange(int bcoin) async {
    Resp<Null> resp = await dio.put('/user/info/$bcoin');
    return resp;
  }

  /// b币记录（用户态）
  static Future<Resp<List<Map<String, dynamic>>>> getBCoinHistory() async {
    Resp resp = await dio.fetch('/user/bCoinList');
    resp.data = jsonDecode(resp.data ?? '[]');
    // 因为后台网关的破坏
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data?.cast<Map<String, dynamic>>(),
    );
  }

  /// 瓜子记录（用户态）
  static Future<Resp<List<Map<String, dynamic>>>> getGoldSeedHistory() async {
    Resp resp = await dio.fetch('/user/goldenMelonSeedList');
    resp.data = jsonDecode(resp.data ?? '[]');
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data?.cast<Map<String, dynamic>>(),
    );
  }
}
