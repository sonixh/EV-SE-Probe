class MeterStatus {
  final String meterId;
  final String meterName;
  final String powerFactor;
  final String frequency;
  final String lineCurrent;
  final String lineVoltage;
  final String powerFlowReal;
  final String powerFlowReactive;
  final String powerFlowTotal;
  final String energyDown;
  final String energyUp;
  final String energyNet;
  final String timeStamp;

  MeterStatus(
      {this.meterId,
      this.meterName,
      this.powerFactor,
      this.frequency,
      this.lineCurrent,
      this.lineVoltage,
      this.powerFlowReal,
      this.powerFlowReactive,
      this.powerFlowTotal,
      this.energyDown,
      this.energyUp,
      this.energyNet,
      this.timeStamp});

  factory MeterStatus.fromJson(Map<String, dynamic> json) {
    return MeterStatus(
      meterId: json['meter_id'],
      powerFactor: json['power_factor'],
      meterName: json['meter_name'],
      frequency: json['frequency'],
      lineCurrent: json['line_current'],
      lineVoltage: json['line_voltage'],
      powerFlowReal: json['power_flow_real_kw'],
      powerFlowReactive: json['power_flow_reactive_kvar'],
      powerFlowTotal: json['power_flow_total_kva'],
      energyDown: json['energy_down_kwh'],
      energyNet: json['energy_net_kwh'],
      energyUp: json['energy_up_kwh'],
      timeStamp: json['timestamp'],
    );
  }

  Map<String, String> get map {
    return {
      "Meter Id ": meterId,
      "Meter Name ": meterName,
      'Reported At ': timeStamp,
      'Univ epoch time ': DateTime.now().millisecondsSinceEpoch.toString(),
      "Power Factor ": powerFactor,
      "Frequency ": frequency,
      "Line Current (A) ": lineCurrent,
      "Line Voltage (V) ": lineVoltage,
      "Power Flow Real (kW) ": powerFlowReal,
      "Power Flow Reactive (kVAR) ": powerFlowReactive,
      "Power Flow Total (kVA) ": powerFlowTotal,
      "Energy Down (kWh) ": energyDown,
      'Energy Up (kWh) ': energyUp,
      'Net Energy (kWh) ': energyNet,
    };
  }
}
