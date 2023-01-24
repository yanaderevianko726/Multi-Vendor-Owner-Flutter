class UpdateStatusBody {
  String token;
  int orderId;
  String status;
  String otp;
  String processingTime;
  String method = 'put';

  UpdateStatusBody({this.token, this.orderId, this.status, this.otp, this.processingTime});

  UpdateStatusBody.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    orderId = json['order_id'];
    status = json['status'];
    otp = json['otp'];
    processingTime = json['processing_time'];
    status = json['_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['otp'] = this.otp;
    data['processing_time'] = this.processingTime;
    data['_method'] = this.method;
    return data;
  }
}