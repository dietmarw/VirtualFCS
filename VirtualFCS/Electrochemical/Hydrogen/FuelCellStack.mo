within VirtualFCS.Electrochemical.Hydrogen;

model FuelCellStack 
//*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Cathode_Medium = Modelica.Media.Air.MoistAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  //*** DECLARE PARAMETERS ***//
  // Physical parameters
  // Fuel Cell Stack Paramters
  parameter Real m_FC_stack(unit = "kg") = 42 "FC stack mass";
  parameter Real L_FC_stack(unit = "m") = 0.420 "FC stack length";
  parameter Real W_FC_stack(unit = "m") = 0.582 "FC stack length";
  parameter Real H_FC_stack(unit = "m") = 0.156 "FC stack length";
  parameter Real vol_FC_stack(unit = "m3") = L_FC_stack * W_FC_stack * H_FC_stack "FC stack volume";
  parameter Real I_rated_FC_stack(unit="A") = 450 "FC stack rated current";
  parameter Real i_L_FC_stack(unit = "A") = 760 "FC stack cell maximum limiting current";
  parameter Real N_FC_stack(unit = "1") = 455 "FC stack number of cells";
  parameter Real A_FC_surf(unit = "m2") = 2 * (L_FC_stack * W_FC_stack) + 2 * (L_FC_stack * H_FC_stack) + 2 * (W_FC_stack * H_FC_stack) "FC stack surface area";
  // Electrochemical parameters
  parameter Real i_0_FC_stack(unit = "A") = 0.0091 "FC stack cell exchange current";
  parameter Real i_x_FC_stack(unit = "A") = 0.001 "FC stack cell cross-over current";
  parameter Real b_1_FC_stack(unit = "V/dec") = 0.0985 "FC stack cell Tafel slope";
  parameter Real b_2_FC_stack(unit = "V/dec") = 0.0985 "FC stack cell trasport limitation factor";
  parameter Real R_0_FC_stack(unit = "Ohm") = 0.00022*N_FC_stack "FC stack cell ohmic resistance";

// Thermal parameters
  parameter Real Cp_FC_stack(unit = "J/(kg.K)") = 1100 "FC stack specific heat capacity";
  //*** DECLARE VARIABLES ***//
  // Physical constants
  Real R = 8.314;
  Real F = 96485;
  // Fuel cell variables
  Real V_cell;
  Real P_th;
  Real p_H2(min = 0);
  Real p_O2(min = 0);
  Real p_0 = 100000;
  //*** INSTANTIATE COMPONENTS ***//
  //System
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(visible = true, transformation(extent = {{-140, -142}, {-120, -122}}, rotation = 0)));
  // Electrical Components
  // Fluid Components
  Modelica.Fluid.Fittings.TeeJunctionIdeal qH2(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-118, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_H2(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_H2(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-148, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_Coolant(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {-134, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_Coolant(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {130, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipeCoolant(redeclare package Medium = Coolant_Medium, T_start = 293.15, diameter = 0.003, length = 1, modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, nNodes = 1, nParallel = 500, p_a_start = 102502, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {0, -42}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_Air(redeclare package Medium = Cathode_Medium) annotation(
    Placement(visible = true, transformation(origin = {150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_Air(redeclare package Medium = Cathode_Medium) annotation(
    Placement(visible = true, transformation(origin = {150, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal qAir(redeclare package Medium = Cathode_Medium) annotation(
    Placement(visible = true, transformation(origin = {120, 40}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T O2_sink(redeclare package Medium = Cathode_Medium, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {84, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Thermal Components
  // Other Components
  Modelica.Fluid.Sources.MassFlowSource_T H2_sink(redeclare package Medium = Anode_Medium, nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-80, 41}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R_ohmic(R = R_0_FC_stack) annotation(
    Placement(visible = true, transformation(origin = {60, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Sources.SignalVoltage potentialSource annotation(
    Placement(visible = true, transformation(origin = {-60, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain H2_mflow(k = 0.00202 / (96485 * 2) * N_FC_stack) annotation(
    Placement(visible = true, transformation(origin = {-26, 59}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Gain O2_mflow(k = 0.032 / (96485 * 4) * N_FC_stack) annotation(
    Placement(visible = true, transformation(origin = {34, 60}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 1777) annotation(
    Placement(visible = true, transformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(visible = true, transformation(origin = {0, -144}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = Cp_FC_stack * m_FC_stack, T(fixed = true, start = 293.15), der_T(fixed = false)) annotation(
    Placement(visible = true, transformation(origin = {0, -104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(visible = true, transformation(origin = {48, -114}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-100, 128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(visible = true, transformation(origin = {-50, -92}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
equation
//*** DEFINE EQUATIONS ***//
// Redeclare variables
  p_H2 = H2_sink.ports[1].p;
  p_O2 = 0.2 * O2_sink.ports[1].p;
// ELECTROCHEMICAL EQUATIONS //
// Calculate the stack voltage
  potentialSource.v = N_FC_stack * (1.229 - R * temperatureSensor.T / (2 * F) * log(1 / (p_H2 / p_0 * (p_O2 / p_0) ^ 0.5)) - b_1_FC_stack * log10((abs(currentSensor.i) + i_x_FC_stack) / i_0_FC_stack) + b_2_FC_stack * log10(1 - (abs(currentSensor.i) + i_x_FC_stack) / i_L_FC_stack));
// Calculate the voltage of the cell
  V_cell = pin_p.v / N_FC_stack;
// THERMAL EQUATIONS //
  P_th = (1.481 - V_cell) * currentSensor.i + currentSensor.i ^ 2 * R_ohmic.R_actual;
// Assign the thermal power value to the heat flow component
  prescribedHeatFlow.Q_flow = P_th;
//*** DEFINE CONNECTIONS ***//
  connect(pipeCoolant.port_b, port_b_Coolant) annotation(
    Line(points = {{10, -42}, {130, -42}}, color = {0, 127, 255}, thickness = 1));
  connect(pipeCoolant.port_a, port_a_Coolant) annotation(
    Line(points = {{-10, -42}, {-134, -42}}, color = {0, 127, 255}, thickness = 1));
  connect(port_a_H2, qH2.port_1) annotation(
    Line(points = {{-148, 80}, {-118, 80}, {-118, 50}, {-118, 50}}));
  connect(port_b_H2, qH2.port_2) annotation(
    Line(points = {{-150, 0}, {-118, 0}, {-118, 30}, {-118, 30}}));
  connect(port_a_Air, qAir.port_1) annotation(
    Line(points = {{150, 80}, {120, 80}, {120, 50}, {120, 50}}));
  connect(qAir.port_2, port_b_Air) annotation(
    Line(points = {{120, 30}, {120, 30}, {120, -2}, {150, -2}, {150, -2}}));
  connect(O2_sink.ports[1], qAir.port_3) annotation(
    Line(points = {{94, 40}, {110, 40}, {110, 40}, {110, 40}}, color = {0, 127, 255}));
  connect(qH2.port_3, H2_sink.ports[1]) annotation(
    Line(points = {{-108, 40}, {-90, 40}, {-90, 42}, {-90, 42}}, color = {0, 127, 255}));
  connect(R_ohmic.n, pin_p) annotation(
    Line(points = {{60, 130}, {60, 150}}, color = {0, 0, 255}));
  connect(pin_n, potentialSource.n) annotation(
    Line(points = {{-60, 150}, {-60, 150}, {-60, 130}, {-60, 130}}, color = {0, 0, 255}));
  connect(O2_mflow.y, O2_sink.m_flow_in) annotation(
    Line(points = {{43, 60}, {74, 60}, {74, 48}}, color = {0, 0, 127}));
  connect(H2_mflow.y, H2_sink.m_flow_in) annotation(
    Line(points = {{-35, 59}, {-68, 59}, {-68, 50}, {-70, 50}}, color = {0, 0, 127}));
  connect(thermalConductor.port_b, pipeCoolant.heatPorts[1]) annotation(
    Line(points = {{0, -56}, {0, -56}, {0, -46}, {0, -46}}, color = {191, 0, 0}));
  connect(thermalConductor.port_a, heatCapacitor.port) annotation(
    Line(points = {{0, -76}, {0, -76}, {0, -114}, {0, -114}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{0, -114}, {0, -114}, {0, -144}, {0, -144}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, prescribedHeatFlow.port) annotation(
    Line(points = {{0, -114}, {38, -114}, {38, -114}, {38, -114}}, color = {191, 0, 0}));
  connect(pin_n, ground.p) annotation(
    Line(points = {{-60, 150}, {-100, 150}, {-100, 138}, {-100, 138}}, color = {0, 0, 255}));
  connect(temperatureSensor.port, heatCapacitor.port) annotation(
    Line(points = {{-50, -102}, {-50, -102}, {-50, -114}, {2, -114}, {2, -114}, {0, -114}}, color = {191, 0, 0}));
  connect(temperatureSensor.T, H2_sink.T_in) annotation(
    Line(points = {{-50, -82}, {-50, -82}, {-50, 44}, {-68, 44}, {-68, 46}}, color = {0, 0, 127}));
  connect(currentSensor.p, R_ohmic.p) annotation(
    Line(points = {{10, 100}, {60, 100}, {60, 110}, {60, 110}}, color = {0, 0, 255}));
  connect(currentSensor.n, potentialSource.p) annotation(
    Line(points = {{-10, 100}, {-60, 100}, {-60, 110}, {-60, 110}}, color = {0, 0, 255}));
  connect(currentSensor.i, H2_mflow.u) annotation(
    Line(points = {{0, 90}, {-4, 90}, {-4, 58}, {-16, 58}, {-16, 60}}, color = {0, 0, 127}));
  connect(currentSensor.i, O2_mflow.u) annotation(
    Line(points = {{0, 90}, {10, 90}, {10, 60}, {24, 60}, {24, 60}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1), graphics = {Line(origin = {20.1754, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {80, 0}, fillColor = {0, 178, 227}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Line(origin = {40.1315, 2}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {0.219199, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {-40.0001, 1.61404}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {-80, 0}, fillColor = {170, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Text(origin = {10, -54}, lineColor = {255, 0, 0}, extent = {{-11, 6}, {11, -6}}, textString = "K"), Line(origin = {-20.0439, -0.307018}, points = {{0, 80}, {0, -80}, {0, -80}}), Rectangle(origin = {35, 54}, fillColor = {177, 177, 177}, fillPattern = FillPattern.Vertical, extent = {{-95, 26}, {25, -134}}), Text(origin = {-80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "A"), Text(origin = {80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "C")}),
    version = "",
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>This model describes the dynamic behaviour of a proton exchange membrane fuel cell (PEMFC) stack. The model includes components describing the electrical, fluidic, and thermal properties of the stack.&nbsp;<div><br></div><div>The electrical performance is modelled using a 0-D polarization curve model to calculate the activation amd mass-transport overpotentials, and a simple resistor to calculate Ohmic voltage loss.</div><div><br></div><div>The fluidic performance is modelled using simple ideal flow components for the air and hydrogen gas lines, connected to mass sink boundary conditions. The magnitude of the mass sink is coupled to the electrical current in the stack using Faraday's law.&nbsp;&nbsp;
</div><div><br></div><div>The thermal performance is considered by coupling a model describing the flow of liquid coolant to a thermal heat source. The magnitude of the heat source is calculated using the higher heating value of hydrogen and the calculated electrical voltage of the cell.<div><br></div><div><br>&nbsp; 

<table border=\"0.9\"><caption style=\"text-align: left;\" align=\"Left\"><strong><u>Default Parameters</u></strong></caption><caption style=\"text-align: left;\" align=\"Left\"><strong><u><br></u></strong></caption>
<tbody>
<tr>
<th>Parameter name</th>
<th>Value</th>
<th>Unit</th>
</tr>
<tr>
<td align=\"Left\">mass</td>
<td>=50</td>
<td align=\"Right\">kg</td>
</tr>
<tr>
<td align=\"Left\">volume</td>
<td>=0.001</td>
<td align=\"Right\">m<sup>3</sup></td>
</tr>
<tr>
<td align=\"Left\">Cp</td>
<td>=1100</td>
<td align=\"Left\">J/(kg.K)</td>
</tr>
<tr>
<td align=\"Left\">N_FC_stack</td>
<td>=90</td>
<td align=\"Right\">-</td>
</tr>
<tr>
<td align=\"Left\">A_cell</td>
<td>=0.0237</td>
<td align=\"Right\">m<sup>2</sup></td>
</tr>
<tr>
<td align=\"Left\">i_0</td>
<td>=2</td>
<td align=\"Right\">A</td>
</tr>
<tr>
<td align=\"Left\">i_L</td>
<td>=510</td>
<td align=\"Right\">A</td>
</tr>
<tr>
<td align=\"Left\">i_x</td>
<td>=0.001</td>
<td align=\"Right\">A</td>
</tr>
<tr>
<td align=\"Left\">b_1</td>
<td>=0.025</td>
<td align=\"Right\">V/dec</td>
</tr>
<tr>
<td align=\"Left\">b_2</td>
<td>=0.25</td>
<td align=\"Right\">V/dec</td>
</tr>
<tr>
<td align=\"Left\">R_0</td>
<td>=0.02</td>
<td align=\"Right\">Ohm</td>
</tr>
<tr>
<td align=\"Left\">R_1</td>
<td>=0.01</td>
<td align=\"Right\">Ohm</td>
</tr>
<tr>
<td align=\"Left\">C_1</td>
<td>=0.003</td>
<td align=\"Right\">F</td>
</tr>
</tbody>
</table><br><br><br>



<div><span style=\"text-decoration: underline;\"><strong>Electrochemical equations: </strong></span></div>
<p><strong>The Nernst equilibrium potential</strong><strong>&nbsp;</strong></p>
<p>U<sub>FC</sub><sup>Nernst </sup>= N<sub>cell <sup>. </sup></sub>(U<sup>0</sup> -((RT)/(2F) ln( 1/(p<sub>H2</sub> (p<sub>O2</sub><sup>0.5</sup>)))</p>
<p><span style=\"text-decoration: underline;\"><strong>Activation overpotential</strong></span><strong>&nbsp; &nbsp;</strong></p>
<p>η<sup>act </sup>= N<sub>cell </sub> <sub><sup>. </sup></sub>(b<sub>1 </sub>ln( 1-(i<sub>FC </sub>+ i<sub>x</sub>) / i<sub>0</sub>))</p>
<p><strong>Concentration overpotential</strong></p>
<p>η<sup>con </sup>= N<sub>cell <sup>. </sup></sub>(b<sub>2 </sub>ln( 1-(i<sub>FC </sub>+ i<sub>x</sub>) / i<sub>L</sub>))</p>
<p><span style=\"text-decoration: underline;\"><strong>Thermal equations:</strong> </span></p>
<p><strong>Electrochemical heat generation</strong></p>
<p>Q<sub>FC</sub><sup>rea </sup>= 1.481- (U<sub>FC</sub>i<sub>FC</sub>)</p>
<p><strong>Joule heating</strong></p>
<p>Q<sub>FC</sub><sup>Joule </sup>= i<sub>FC</sub><sup>2</sup> R<sub>FC</sub><sup>Ohm</sup></p>
<p>&nbsp;</p>


</div></div></body></html>"));
end FuelCellStack;
