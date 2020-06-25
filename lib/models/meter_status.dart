class MeterStatus {
  final String meterId;
  final String meterName;
  final String powerFactor;
  final String frequency;
  final String lineCurrent;
  final String lineVoltage;
  final String status;
  final String powerFlowReal;
  final String powerFlowReactive;
  final String powerFlowTotal;

  MeterStatus(
      {this.meterId,
      this.meterName,
      this.powerFactor,
      this.frequency,
      this.lineCurrent,
      this.lineVoltage,
      this.status,
      this.powerFlowReal,
      this.powerFlowReactive,
      this.powerFlowTotal});

  factory MeterStatus.fromJson(Map<String, dynamic> json) {
    return MeterStatus(
        meterId: json['meter_id'],
        powerFactor: json['power_factor'],
        meterName: json['meter_name'],
        frequency: json['frequency'],
        lineCurrent: json['line_current'],
        lineVoltage: json['line_voltage'],
        status: json['status'],
        powerFlowReal: json['power_flow_real_kw'],
        powerFlowReactive: json['power_flow_reactive_kvar'],
        powerFlowTotal: json['power_flow_total_kva']);
  }

  Map<String, String> get map {
    return {
      "Meter Id ": meterId,
      "Meter Name ": meterName,
      "Power Factor ": powerFactor,
      "Frequency ": frequency,
      "Line Current (A) ": lineCurrent,
      "Line Voltage (V) ": lineVoltage,
      "Status ": status,
      "Power Flow Real (kW) ": powerFlowReal,
      "Power Flow Reactive (kVAR) ": powerFlowReactive,
      "Power Flow Total (kVA) ": powerFlowTotal
    };
  }
}
