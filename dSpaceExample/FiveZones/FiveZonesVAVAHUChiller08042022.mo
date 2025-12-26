within dSpaceExample.FiveZones;
model FiveZonesVAVAHUChiller08042022 "System example for fault injection"
  extends dSpaceExample.FiveZones.BaseClasses.PartialHotWaterside(
    final Q_flow_boi_nominal=designHeatLoad,
    minFloBypHW(k=0.1),
    pumSpeHW(reset=Buildings.Types.Reset.Parameter, y_reset=0),
    boiTSup(
      y_start=0,
      reset=Buildings.Types.Reset.Parameter,
      y_reset=0),
    boi(show_T=false),
    triResHW(TMin=313.15, TMax=321.15));
  extends dSpaceExample.FiveZones.BaseClasses.PartialAirsideFiveZonesAHU(
    fanSup(show_T=false),
    conAHU(
      pNumIgnReq=1,
      TSupSetMin=284.95,
      numIgnReqSupTem=1,
      kTSup=0.5,
      TiTSup=120),
    conVAVWes(
      VDisSetMin_flow=0.05*conVAVWes.V_flow_nominal,
      VDisConMin_flow=0.05*conVAVWes.V_flow_nominal,
      errTZonCoo_1=0.8,
      errTZonCoo_2=0.4,
      sysReq(gai1(k=0.7), gai2(k=0.9))),
    conVAVCor(
      VDisSetMin_flow=0.05*conVAVCor.V_flow_nominal,
      VDisConMin_flow=0.05*conVAVCor.V_flow_nominal,
      errTZonCoo_1=0.8,
      errTZonCoo_2=0.4,
      sysReq(gai1(k=0.7), gai2(k=0.9))),
    conVAVSou(
      VDisSetMin_flow=0.05*conVAVSou.V_flow_nominal,
      VDisConMin_flow=0.05*conVAVSou.V_flow_nominal,
      errTZonCoo_1=0.8,
      errTZonCoo_2=0.4,
      sysReq(gai1(k=0.7), gai2(k=0.9))),
    conVAVEas(
      VDisSetMin_flow=0.05*conVAVEas.V_flow_nominal,
      VDisConMin_flow=0.05*conVAVEas.V_flow_nominal,
      errTZonCoo_1=0.8,
      errTZonCoo_2=0.4,
      sysReq(gai1(k=0.7), gai2(k=0.9))),
    conVAVNor(
      VDisSetMin_flow=0.05*conVAVNor.V_flow_nominal,
      VDisConMin_flow=0.05*conVAVNor.V_flow_nominal,
      errTZonCoo_1=0.8,
      errTZonCoo_2=0.4,
      sysReq(gai1(k=0.7), gai2(k=0.9))),
    flo(
      cor(T_start=273.15 + 24),
      sou(T_start=273.15 + 24),
      eas(T_start=273.15 + 24),
      wes(T_start=273.15 + 24),
      nor(T_start=273.15 + 24)),
    occSch(occupancy=3600*{7,20}),
    eco(allowFlowReversal=false));
  extends dSpaceExample.FiveZones.BaseClasses.PartialWaterside(
    redeclare
      FaultInjection.Experimental.SystemLevelFaults.BaseClasses.IntegratedPrimaryLoadSide
      chiWSE(
      use_inputFilter=true,
      T2_start=283.15,
      addPowerToMedium=false,
      perPum=perPumPri),
    watVal(
      redeclare package Medium = MediumW,
      m_flow_nominal=m2_flow_chi_nominal,
      dpValve_nominal=6000,
      riseTime=60),
    final QEva_nominal=designCoolLoad,
    pumCW(use_inputFilter=true),
    resCHW(dp_nominal=139700),
    temDifPreRes(
      samplePeriod(displayUnit="s"),
      uTri=0.9,
      dpMin=0.5*dpSetPoi,
      dpMax=dpSetPoi,
      TMin(displayUnit="degC") = 278.15,
      TMax(displayUnit="degC") = 283.15),
    pumSpe(yMin=0.2),
    TCHWSup(T_start=283.15),
    CHWSTDelAtt(delayTime=600));

  extends dSpaceExample.FiveZones.BaseClasses.EnergyMeter(
    eleCoiVAV(y=cor.terHea.Q1_flow + nor.terHea.Q1_flow + wes.terHea.Q1_flow +
          eas.terHea.Q1_flow + sou.terHea.Q1_flow),
    eleSupFan(y=fanSup.P),
    eleChi(y=chiWSE.powChi[1]),
    eleCHWP(y=chiWSE.powPum[1]),
    eleCWP(y=pumCW.P),
    eleHWP(y=pumHW.P),
    eleCT(y=cooTow.PFan),
    gasBoi(y=boi.QFue_flow));

 extends dSpaceExample.FiveZones.BaseClasses.RunTime;

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumPri(
    each pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp2_chi_nominal+dp2_wse_nominal+139700+36000)*{1.5,1.3,1.0,0.6}))
    "Performance data for primary pumps";

  FaultInjection.Experimental.SystemLevelFaults.Controls.CoolingMode cooModCon(
    tWai=1200,
    deaBan1=1.1,
    deaBan2=0.5,
    deaBan3=1.1,
    deaBan4=0.5) "Cooling mode controller"
    annotation (Placement(transformation(extent={{1028,-266},{1048,-246}})));
  Modelica.Blocks.Sources.RealExpression towTApp(y=cooTow.TWatOut_nominal -
        cooTow.TAirInWB_nominal)
    "Cooling tower approach temperature"
    annotation (Placement(transformation(extent={{988,-300},{1008,-280}})));
  Modelica.Blocks.Sources.RealExpression yVal5(y=if cooModCon.y == Integer(
        FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.FullMechanical)
         then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{1060,-192},{1040,-172}})));
  Modelica.Blocks.Sources.RealExpression yVal6(y=if cooModCon.y == Integer(
        FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.FreeCooling)
         then 1 else 0)
    "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{1060,-208},{1040,-188}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proCHWP
    annotation (Placement(transformation(extent={{1376,-260},{1396,-240}})));

  FaultInjection.Experimental.SystemLevelFaults.Controls.PlantRequest plaReqChi
    annotation (Placement(transformation(extent={{1044,-112},{1064,-92}})));
  FaultInjection.Experimental.SystemLevelFaults.Controls.ChillerPlantEnableDisable
    chiPlaEnaDis(yFanSpeMin=0.1,
                 plaReqTim=30*60)
    annotation (Placement(transformation(extent={{1100,-120},{1120,-100}})));
  Modelica.Blocks.Math.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{1168,-126},{1188,-106}})));
  FaultInjection.Experimental.SystemLevelFaults.Controls.BoilerPlantEnableDisable
    boiPlaEnaDis(
    yFanSpeMin=0.15,
    plaReqTim=30*60,
    TOutPla=291.15)
    annotation (Placement(transformation(extent={{-278,-170},{-258,-150}})));
  Modelica.Blocks.Math.BooleanToReal booToReaHW
    annotation (Placement(transformation(extent={{-218,-170},{-198,-150}})));
  FaultInjection.Experimental.SystemLevelFaults.Controls.PlantRequest plaReqBoi
    annotation (Placement(transformation(extent={{-320,-170},{-300,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proHWVal
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proCHWVal
    annotation (Placement(transformation(extent={{468,-118},{488,-98}})));

  FaultInjection.Experimental.SystemLevelFaults.Controls.MinimumFlowBypassValve
    minFloBypCHW(m_flow_minimum=0.5, k=0.1)
    "Chilled water loop minimum bypass valve control"
    annotation (Placement(transformation(extent={{1040,-160},{1060,-140}})));
  Modelica.Blocks.Sources.RealExpression yVal7(y=if cooModCon.y == Integer(
        FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.FreeCooling)
         then 0 else minFloBypCHW.y) "On/off signal for valve 7"
    annotation (Placement(transformation(extent={{1060,-230},{1040,-210}})));

  Modelica.Blocks.Math.BooleanToReal booToReaSupFan
    annotation (Placement(transformation(extent={{1220,642},{1240,662}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
       0.01)
    annotation (Placement(transformation(extent={{1220,688},{1240,708}})));
  Modelica.Blocks.Math.BooleanToReal booToReaCT
    annotation (Placement(transformation(extent={{1254,688},{1274,708}})));

  UnitConversion.KToF kToF1
    annotation (Placement(transformation(extent={{1100,700},{1120,720}})));
  UnitConversion.ToAnolog toV1(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=5)  "25/125F mapping to 0-10v"
    annotation (Placement(transformation(extent={{1132,700},{1152,720}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAirSou_V "Room air temperature"
    annotation (Placement(transformation(extent={{1164,700},{1184,720}}),
        iconTransformation(extent={{260,20},{280,40}})));
  Modelica.Blocks.Sources.RealExpression reaTDryBul(y=chicago.wea.y[7])
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-390,146},{-370,166}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBul
    annotation (Placement(transformation(extent={{-300,100},{-280,120}})));
  Modelica.Blocks.Sources.RealExpression reaRH(y=chicago.wea.y[13])
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-390,126},{-370,146}})));
  Modelica.Blocks.Sources.RealExpression reaPre(y=chicago.wea.y[23])
    "Outdoor air pressure (pa)"
    annotation (Placement(transformation(extent={{-390,92},{-370,112}})));
  UnitConversion.FromAnalog volToUni_yhea1(
    v_min=0.1,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{488,22},{500,34}})));
  Modelica.Blocks.Interfaces.RealInput yHeaCor
    "Voltage signal for heating coil" annotation (Placement(transformation(
          extent={{454,14},{482,42}}), iconTransformation(extent={{-120,-58},{
            -92,-30}})));
  UnitConversion.KToF kToF2
    annotation (Placement(transformation(extent={{1100,672},{1120,692}})));
  UnitConversion.ToAnolog toV2(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=5)  "25/125F mapping to 0-10v"
    annotation (Placement(transformation(extent={{1132,672},{1152,692}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAirEas_V "Room air temperature"
    annotation (Placement(transformation(extent={{1164,672},{1184,692}}),
        iconTransformation(extent={{260,0},{280,20}})));
  UnitConversion.KToF kToF3
    annotation (Placement(transformation(extent={{1100,620},{1120,640}})));
  UnitConversion.ToAnolog toV3(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=5)  "25/125F mapping to 0-10v"
    annotation (Placement(transformation(extent={{1132,620},{1152,640}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAirNor_V "Room air temperature"
    annotation (Placement(transformation(extent={{1164,620},{1184,640}}),
        iconTransformation(extent={{260,-20},{280,0}})));
  UnitConversion.KToF kToF4
    annotation (Placement(transformation(extent={{1100,590},{1120,610}})));
  UnitConversion.ToAnolog toV4(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=5)  "25/125F mapping to 0-10v"
    annotation (Placement(transformation(extent={{1132,590},{1152,610}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAirWes_V "Room air temperature"
    annotation (Placement(transformation(extent={{1164,590},{1184,610}}),
        iconTransformation(extent={{260,-40},{280,-20}})));
  UnitConversion.KToF kToF5
    annotation (Placement(transformation(extent={{1100,550},{1120,570}})));
  UnitConversion.ToAnolog toV5(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=5)  "25/125F mapping to 0-10v"
    annotation (Placement(transformation(extent={{1132,550},{1152,570}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAirCor_V "Room air temperature"
    annotation (Placement(transformation(extent={{1164,550},{1184,570}}),
        iconTransformation(extent={{260,-60},{280,-40}})));
  UnitConversion.ToAnolog toV6(
    x_min=0,
    x_max=10000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{530,332},{550,352}})));
  UnitConversion.VToCFM vToCFM_vav1
    annotation (Placement(transformation(extent={{500,332},{520,352}})));
  Modelica.Blocks.Interfaces.RealOutput VCor_flow_V
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{558,332},{578,352}}), iconTransformation(extent=
           {{320,-58},{340,-38}})));
  UnitConversion.ToAnolog toV7(
    x_min=0,
    x_max=3000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{702,330},{722,350}})));
  UnitConversion.VToCFM vToCFM_vav2
    annotation (Placement(transformation(extent={{672,330},{692,350}})));
  Modelica.Blocks.Interfaces.RealOutput VSou_flow_V
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{734,330},{754,350}}), iconTransformation(extent=
           {{320,22},{340,42}})));
  UnitConversion.ToAnolog toV8(
    x_min=0,
    x_max=3000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{914,330},{934,350}})));
  UnitConversion.VToCFM vToCFM_vav3
    annotation (Placement(transformation(extent={{884,330},{904,350}})));
  Modelica.Blocks.Interfaces.RealOutput VEas_flow_V
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{946,330},{966,350}}), iconTransformation(extent=
           {{320,2},{340,22}})));
  UnitConversion.ToAnolog toV9(
    x_min=0,
    x_max=3000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{1072,330},{1092,350}})));
  UnitConversion.VToCFM vToCFM_vav4
    annotation (Placement(transformation(extent={{1042,330},{1062,350}})));
  Modelica.Blocks.Interfaces.RealOutput VNor_flow_V
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{1106,330},{1126,350}}), iconTransformation(
          extent={{320,-18},{340,2}})));
  UnitConversion.ToAnolog toV10(
    x_min=0,
    x_max=3000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{1236,332},{1256,352}})));
  UnitConversion.VToCFM vToCFM_vav5
    annotation (Placement(transformation(extent={{1206,332},{1226,352}})));
  Modelica.Blocks.Interfaces.RealOutput VWes_flow_V
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{1268,332},{1288,352}}), iconTransformation(
          extent={{320,-38},{340,-18}})));
  UnitConversion.KToF kToF6
    annotation (Placement(transformation(extent={{500,270},{520,290}})));
  UnitConversion.ToAnolog toV11(
    x_min=45,
    x_max=95,
    v_min=0,
    v_max=5) "0C-50C mapping to 0 - 5V"
    annotation (Placement(transformation(extent={{530,270},{550,290}})));
  Modelica.Blocks.Interfaces.RealOutput TDisCor_V
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{560,270},{580,290}}), iconTransformation(extent={{200,-60},{
            220,-40}})));
  UnitConversion.ToAnolog toV12(
    x_min=45,
    x_max=95,
    v_min=0,
    v_max=5) "0C-50C mapping to 0 - 5V"
    annotation (Placement(transformation(extent={{704,270},{724,290}})));
  Modelica.Blocks.Interfaces.RealOutput TDisSou_V
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{734,270},{754,290}}), iconTransformation(extent={{200,20},{
            220,40}})));
  UnitConversion.KToF kToF7
    annotation (Placement(transformation(extent={{670,270},{690,290}})));
  UnitConversion.ToAnolog toV13(
    x_min=45,
    x_max=95,
    v_min=0,
    v_max=5) "0C-50C mapping to 0 - 5V"
    annotation (Placement(transformation(extent={{916,270},{936,290}})));
  Modelica.Blocks.Interfaces.RealOutput TDisEas_V
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{946,270},{966,290}}), iconTransformation(extent={{200,0},{
            220,20}})));
  UnitConversion.KToF kToF8
    annotation (Placement(transformation(extent={{886,270},{906,290}})));
  UnitConversion.ToAnolog toV14(
    x_min=45,
    x_max=95,
    v_min=0,
    v_max=5) "0C-50C mapping to 0 - 5V"
    annotation (Placement(transformation(extent={{1082,270},{1102,290}})));
  UnitConversion.KToF kToF9
    annotation (Placement(transformation(extent={{1052,270},{1072,290}})));
  Modelica.Blocks.Interfaces.RealOutput TDisNor_V
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{1112,270},{1132,290}}), iconTransformation(extent={{200,-20},
            {220,0}})));
  UnitConversion.ToAnolog toV15(
    x_min=45,
    x_max=95,
    v_min=0,
    v_max=5) "0C-50C mapping to 0 - 5V"
    annotation (Placement(transformation(extent={{1242,270},{1262,290}})));
  UnitConversion.KToF kToF10
    annotation (Placement(transformation(extent={{1212,270},{1232,290}})));
  Modelica.Blocks.Interfaces.RealOutput TDisWes_V
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{1270,270},{1290,290}}), iconTransformation(extent={{200,-40},
            {220,-20}})));
  UnitConversion.FromAnalog volToUni_yvav1(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{488,54},{500,66}})));
  Modelica.Blocks.Interfaces.RealInput yVAVCor "Voltage signal for VAV damper"
    annotation (Placement(transformation(extent={{-200,-60},{-172,-32}}),
        iconTransformation(extent={{-200,-60},{-172,-32}})));
  UnitConversion.FromAnalog volToUni_yhea2(
    v_min=0.1,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{660,22},{672,34}})));
  UnitConversion.FromAnalog volToUni_yvav2(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{660,54},{672,66}})));
  Modelica.Blocks.Interfaces.RealInput yHeaSou
    "Voltage signal for heating coil" annotation (Placement(transformation(
          extent={{626,14},{654,42}}), iconTransformation(extent={{-120,54},{
            -92,82}})));
  Modelica.Blocks.Interfaces.RealInput yVAVSou "Voltage signal for VAV damper"
    annotation (Placement(transformation(extent={{626,46},{654,74}}),
        iconTransformation(extent={{-200,52},{-172,80}})));
  UnitConversion.FromAnalog volToUni_yhea3(
    v_min=0.1,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{844,22},{856,34}})));
  UnitConversion.FromAnalog volToUni_yvav3(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{844,54},{856,66}})));
  Modelica.Blocks.Interfaces.RealInput yHeaEas
    "Voltage signal for heating coil" annotation (Placement(transformation(
          extent={{810,14},{838,42}}), iconTransformation(extent={{-120,26},{
            -92,54}})));
  Modelica.Blocks.Interfaces.RealInput yVAVEas "Voltage signal for VAV damper"
    annotation (Placement(transformation(extent={{810,46},{838,74}}),
        iconTransformation(extent={{-200,24},{-172,52}})));
  UnitConversion.FromAnalog volToUni_yhea4(
    v_min=0.1,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{1004,22},{1016,34}})));
  UnitConversion.FromAnalog volToUni_yvav4(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{1004,54},{1016,66}})));
  Modelica.Blocks.Interfaces.RealInput yHeaNor
    "Voltage signal for heating coil" annotation (Placement(transformation(
          extent={{970,14},{998,42}}), iconTransformation(extent={{-120,-2},{
            -92,26}})));
  Modelica.Blocks.Interfaces.RealInput yVAVNor "Voltage signal for VAV damper"
    annotation (Placement(transformation(extent={{970,46},{998,74}}),
        iconTransformation(extent={{-200,-4},{-172,24}})));
  UnitConversion.FromAnalog volToUni_yhea5(
    v_min=0.1,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{1184,22},{1196,34}})));
  UnitConversion.FromAnalog volToUni_yvav5(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{1184,54},{1196,66}})));
  Modelica.Blocks.Interfaces.RealInput yHeaWes
    "Voltage signal for heating coil" annotation (Placement(transformation(
          extent={{1150,14},{1178,42}}), iconTransformation(extent={{-120,-30},
            {-92,-2}})));
  Modelica.Blocks.Interfaces.RealInput yVAVWes "Voltage signal for VAV damper"
    annotation (Placement(transformation(extent={{1150,46},{1178,74}}),
        iconTransformation(extent={{-200,-32},{-172,-4}})));
  Modelica.Blocks.Interfaces.RealOutput TDisCor
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{596,244},{616,264}}), iconTransformation(extent={{200,-60},{
            220,-40}})));
  Modelica.Blocks.Interfaces.RealOutput VCor_flow
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{596,386},{616,406}}), iconTransformation(extent=
           {{320,-58},{340,-38}})));
  Modelica.Blocks.Interfaces.RealOutput TDisSou
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{778,240},{798,260}}), iconTransformation(extent={{200,20},{
            220,40}})));
  Modelica.Blocks.Interfaces.RealOutput VSou_flow
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{760,392},{780,412}}), iconTransformation(extent=
           {{320,22},{340,42}})));
  Modelica.Blocks.Interfaces.RealOutput TDisEas
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{954,244},{974,264}}), iconTransformation(extent={{200,0},{
            220,20}})));
  Modelica.Blocks.Interfaces.RealOutput VEas_flow
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{962,314},{982,334}}), iconTransformation(extent=
           {{320,2},{340,22}})));
  Modelica.Blocks.Interfaces.RealOutput TDisNor
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{1114,236},{1134,256}}), iconTransformation(extent={{200,-20},
            {220,0}})));
  Modelica.Blocks.Interfaces.RealOutput VNor_flow
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{1122,362},{1142,382}}), iconTransformation(
          extent={{320,-18},{340,2}})));
  Modelica.Blocks.Interfaces.RealOutput TDisWes
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{1288,224},{1308,244}}), iconTransformation(extent={{200,-40},
            {220,-20}})));
  Modelica.Blocks.Interfaces.RealOutput VWes_flow
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{1288,410},{1308,430}}), iconTransformation(
          extent={{320,-38},{340,-18}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAirSou "Room air temperature"
    annotation (Placement(transformation(extent={{968,704},{988,724}}),
        iconTransformation(extent={{260,20},{280,40}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAirEas "Room air temperature"
    annotation (Placement(transformation(extent={{968,678},{988,698}}),
        iconTransformation(extent={{260,0},{280,20}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAirNor "Room air temperature"
    annotation (Placement(transformation(extent={{970,640},{990,660}}),
        iconTransformation(extent={{260,-20},{280,0}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAirWes "Room air temperature"
    annotation (Placement(transformation(extent={{972,596},{992,616}}),
        iconTransformation(extent={{260,-40},{280,-20}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAirCor "Room air temperature"
    annotation (Placement(transformation(extent={{974,570},{994,590}}),
        iconTransformation(extent={{260,-60},{280,-40}})));
  UnitConversion.KToF kToF_TOut
    annotation (Placement(transformation(extent={{-356,270},{-336,290}})));
  Modelica.Blocks.Math.Gain gain(k=100)
    annotation (Placement(transformation(extent={{-356,236},{-336,256}})));
  Modelica.Blocks.Interfaces.RealOutput TOutAir "Outdoor air temp" annotation (
      Placement(transformation(extent={{-330,330},{-310,350}}),
        iconTransformation(extent={{106,-40},{126,-20}})));
  Modelica.Blocks.Interfaces.RealOutput RHOut "Outdoor air rh" annotation (
      Placement(transformation(extent={{-330,310},{-310,330}}),
        iconTransformation(extent={{106,-60},{126,-40}})));
  UnitConversion.ToAnolog toV_TOut(
    x_min=-20,
    x_max=120,
    v_min=0,
    v_max=10) "-20F-120F  mapping to 0 - 5V"
    annotation (Placement(transformation(extent={{-312,270},{-292,290}})));
  UnitConversion.ToAnolog toV_RHOut(
    x_min=0,
    x_max=100,
    v_min=0,
    v_max=10) "1-100 mapping to 0 - 10V"
    annotation (Placement(transformation(extent={{-312,236},{-292,256}})));
  Modelica.Blocks.Interfaces.RealOutput TOut_V "Outdoor air temp" annotation (
      Placement(transformation(extent={{-282,270},{-262,290}}),
        iconTransformation(extent={{80,-40},{100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput RHOut_V "Outdoor air rh" annotation (
      Placement(transformation(extent={{-282,236},{-262,256}}),
        iconTransformation(extent={{80,-60},{100,-40}})));
  Modelica.Blocks.Math.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-312,-28},{-292,-8}})));
  Modelica.Blocks.Interfaces.RealOutput booOcc "occupied status" annotation (
      Placement(transformation(extent={{-284,-28},{-264,-8}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Math.BooleanToReal booToRea2
    annotation (Placement(transformation(extent={{462,682},{482,702}})));
  Modelica.Blocks.Interfaces.RealOutput booSupFan "supply fan status"
    annotation (Placement(transformation(extent={{490,682},{510,702}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput yHeaCoi_deb "heating coil signal"
    annotation (Placement(transformation(extent={{596,500},{616,520}}),
        iconTransformation(extent={{320,-58},{340,-38}})));
  Modelica.Blocks.Interfaces.RealOutput yCooCoi_deb "cooling coil signal"
    annotation (Placement(transformation(extent={{596,476},{616,496}}),
        iconTransformation(extent={{320,-58},{340,-38}})));
  Modelica.Blocks.Interfaces.RealOutput ySupFanSpe_deb
    "supply fan speed signal for debug purpose" annotation (Placement(
        transformation(extent={{544,632},{564,652}}), iconTransformation(extent=
           {{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput TCHWSup_K annotation (Placement(
        transformation(extent={{788,-112},{808,-92}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput TCHWRet_K annotation (Placement(
        transformation(extent={{626,-170},{646,-150}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput THWRet_K annotation (Placement(
        transformation(extent={{126,-170},{146,-150}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput THWSup_K annotation (Placement(
        transformation(extent={{396,-180},{416,-160}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput mHW_SI annotation (Placement(
        transformation(extent={{124,-276},{144,-256}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput mCHW_SI annotation (Placement(
        transformation(extent={{680,-160},{700,-140}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Math.RealToBoolean reaToBoo(threshold=0.8)
    annotation (Placement(transformation(extent={{380,700},{400,720}})));
  Modelica.Blocks.Interfaces.RealInput ySupFanOn
    "Voltage signal for ahu supply fan on/off" annotation (Placement(
        transformation(extent={{350,700},{370,720}}), iconTransformation(extent=
           {{-220,-100},{-200,-80}})));
  UnitConversion.FromAnalog volToUni_6(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{512,612},{530,630}})));
  Modelica.Blocks.Interfaces.RealInput ySupFanSpe
    "Voltage signal for ahu supply fan speed" annotation (Placement(
        transformation(extent={{470,614},{488,632}}), iconTransformation(extent=
           {{-220,-160},{-200,-140}})));
  UnitConversion.FromAnalog volToUni_1(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{408,390},{426,408}})));
  Modelica.Blocks.Interfaces.RealInput yCooVal
    "Voltage signal for ahu cooling valve" annotation (Placement(transformation(
          extent={{382,390},{400,408}}), iconTransformation(extent={{-220,-160},
            {-200,-140}})));
  UnitConversion.FromAnalog volToUni_7(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{-18,-168},{0,-150}})));
  Modelica.Blocks.Interfaces.RealInput yHeaVal
    "Voltage signal for ahu heating valve" annotation (Placement(transformation(
          extent={{-42,-168},{-24,-150}}),
                                         iconTransformation(extent={{-220,-160},
            {-200,-140}})));
  UnitConversion.FromAnalog volToUni_3(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{-106,114},{-88,132}})));
  UnitConversion.FromAnalog volToUni_5(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{-120,146},{-102,164}})));
  UnitConversion.FromAnalog volToUni_4(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{-106,80},{-88,98}})));
  Modelica.Blocks.Interfaces.RealInput yExhDam
    "Voltage signal for exhaust damper position" annotation (Placement(
        transformation(extent={{-136,114},{-118,132}}),
                                                    iconTransformation(extent={{
            -220,-160},{-200,-140}})));
  Modelica.Blocks.Interfaces.RealInput yEcoOADam
    "Voltage signal for economizer OA damper position" annotation (Placement(
        transformation(extent={{-150,146},{-132,164}}),
                                                     iconTransformation(extent={
            {-220,-140},{-200,-120}})));
  Modelica.Blocks.Interfaces.RealInput yRetAirDam
    "Voltage signal for return damper position" annotation (Placement(
        transformation(extent={{-136,80},{-118,98}}), iconTransformation(extent=
           {{-220,-120},{-200,-100}})));
  UnitConversion.KToF kToF14
    annotation (Placement(transformation(extent={{310,72},{330,92}})));
  UnitConversion.ToAnolog toV16(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{338,72},{358,92}})));
  Modelica.Blocks.Interfaces.RealOutput TSup_V "AHU supply air temperature"
                                                                  annotation (
      Placement(transformation(extent={{366,72},{386,92}}),
        iconTransformation(extent={{350,-100},{370,-80}})));
  Modelica.Blocks.Interfaces.RealOutput TSup_ahu1
                                                 "AHU supply air temperature"
    annotation (Placement(transformation(extent={{336,96},{356,116}}),
        iconTransformation(extent={{350,-100},{370,-80}})));
  Modelica.Blocks.Interfaces.RealOutput CCLT_V
    "cooling coil leaving temperature" annotation (Placement(transformation(
          extent={{366,58},{386,78}}), iconTransformation(extent={{350,-140},{370,
            -120}})));
  UnitConversion.KToF kToF17
    annotation (Placement(transformation(extent={{176,46},{196,66}})));
  UnitConversion.ToAnolog toV27(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{202,46},{222,66}})));
  Modelica.Blocks.Interfaces.RealOutput HCLT_V
    "heating coil leaving temperature" annotation (Placement(transformation(
          extent={{232,46},{252,66}}),iconTransformation(extent={{350,-140},{370,
            -120}})));
  Modelica.Blocks.Interfaces.RealOutput CCET_V
    "cooling coil entering temperature" annotation (Placement(transformation(
          extent={{228,76},{248,96}}), iconTransformation(extent={{350,-140},{370,
            -120}})));
  Modelica.Blocks.Interfaces.RealOutput HCLT "heating coil leaving temperature"
    annotation (Placement(transformation(extent={{200,76},{220,96}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  UnitConversion.KToF kToF12
    annotation (Placement(transformation(extent={{32,32},{52,52}})));
  UnitConversion.ToAnolog toV17(
    x_min=-20,
    x_max=120,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{60,32},{80,52}})));
  Modelica.Blocks.Interfaces.RealOutput TMix_V
    "Mixed air temperautre leaviing economizer" annotation (Placement(
        transformation(extent={{94,32},{114,52}}),  iconTransformation(extent={
            {350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput HCET_V
    "heating coil entering temperature" annotation (Placement(transformation(
          extent={{94,14},{114,34}}),  iconTransformation(extent={{350,-140},{370,
            -120}})));
  Modelica.Blocks.Interfaces.RealOutput TMix_ahu
    "Mixed air temperautre leaviing economizer" annotation (Placement(
        transformation(extent={{64,54},{84,74}}),   iconTransformation(extent={{
            350,-140},{370,-120}})));
  UnitConversion.KToF kToF13
    annotation (Placement(transformation(extent={{24,198},{44,218}})));
  UnitConversion.ToAnolog toV22(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{52,198},{72,218}})));
  Modelica.Blocks.Interfaces.RealOutput TRet_ahu_V "ahu return air temperautre"
    annotation (Placement(transformation(extent={{76,198},{96,218}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput TRet_ahu "ahu return air temperautre"
    annotation (Placement(transformation(extent={{48,226},{68,246}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  UnitConversion.ToAnolog toV18(
    x_min=0,
    x_max=22000,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{-124,14},{-106,34}})));
  UnitConversion.VToCFM vToCFM_ahu
    annotation (Placement(transformation(extent={{-154,16},{-138,32}})));
  Modelica.Blocks.Interfaces.RealOutput VOut_flow "Outdoor air flowrate"
    annotation (Placement(transformation(extent={{-132,30},{-112,50}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  Modelica.Blocks.Interfaces.RealOutput VOut_flow_V "Outdoor air flowrate"
    annotation (Placement(transformation(extent={{-96,14},{-76,34}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.ToAnolog toV21(
    x_min=0,
    x_max=22000,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{334,240},{354,260}})));
  UnitConversion.VToCFM vToCFM_ahu1
    annotation (Placement(transformation(extent={{304,240},{324,260}})));
  Modelica.Blocks.Interfaces.RealOutput VRet_flow "Return air flowrate"
    annotation (Placement(transformation(extent={{330,276},{350,296}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  Modelica.Blocks.Interfaces.RealOutput VRet_flow_V "Return air flowrate"
    annotation (Placement(transformation(extent={{366,240},{386,260}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.ToAnolog toV19(
    x_min=0,
    x_max=0.2,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{214,150},{234,170}})));
  UnitConversion.PaToPSI paTopsi_ahu
    annotation (Placement(transformation(extent={{184,150},{204,170}})));
  Modelica.Blocks.Interfaces.RealOutput dpDisSupFan_V
    "Supply fan static discharge pressure" annotation (Placement(transformation(
          extent={{242,150},{262,170}}),iconTransformation(extent={{350,-160},{
            370,-140}})));
  Modelica.Blocks.Interfaces.RealOutput dpDisSupFan_ahu
    "Supply fan static discharge pressure" annotation (Placement(transformation(
          extent={{244,118},{264,138}}), iconTransformation(extent={{350,-160},{
            370,-140}})));
  UnitConversion.ToAnolog toV20(
    x_min=0,
    x_max=1,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{490,714},{510,734}})));
  Modelica.Blocks.Interfaces.RealOutput booSupFan_V "supply fan status"
    annotation (Placement(transformation(extent={{528,714},{548,734}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput booRetFan_V "return fan status"
    annotation (Placement(transformation(extent={{530,688},{550,708}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Math.BooleanToReal booToRea3
    annotation (Placement(transformation(extent={{1100,-168},{1120,-148}})));
  Modelica.Blocks.Interfaces.RealOutput booChiPla_deb "chiller plant status"
    annotation (Placement(transformation(extent={{1128,-168},{1148,-148}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  UnitConversion.ToAnolog toV23(
    x_min=0,
    x_max=22000,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{368,-124},{388,-104}})));
  UnitConversion.VToCFM vToCFM_ahu2
    annotation (Placement(transformation(extent={{338,-124},{358,-104}})));
  Modelica.Blocks.Interfaces.RealOutput VSup_ahu_V "Supply air flowrate"
    annotation (Placement(transformation(extent={{396,-124},{416,-104}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  Modelica.Blocks.Interfaces.RealOutput VSup_ahu "Supply air flowrate"
    annotation (Placement(transformation(extent={{362,-148},{382,-128}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  Modelica.Blocks.Math.BooleanToReal booToRea4
    annotation (Placement(transformation(extent={{1100,-206},{1120,-186}})));
  Modelica.Blocks.Interfaces.RealOutput booChiPla "chiller plant status"
    annotation (Placement(transformation(extent={{1128,-206},{1148,-186}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput Power_fan_V annotation (Placement(
        transformation(extent={{308,-110},{328,-90}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression cooCoiQFlow(y=cooCoi.Q1_flow)
    annotation (Placement(transformation(extent={{206,-118},{226,-98}})));
  Modelica.Blocks.Interfaces.RealOutput cooCoi_Q1 annotation (Placement(
        transformation(extent={{236,-118},{256,-98}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression heaCoiQFlow(y=heaCoi.Q1_flow)
    annotation (Placement(transformation(extent={{206,-136},{226,-116}})));
  Modelica.Blocks.Interfaces.RealOutput heaCoi_Q1 annotation (Placement(
        transformation(extent={{236,-136},{256,-116}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput watVal_yactual annotation (Placement(
        transformation(extent={{504,-150},{524,-130}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression damOut(y=eco.damOut.y_actual)
    annotation (Placement(transformation(extent={{206,-168},{226,-148}})));
  Modelica.Blocks.Interfaces.RealOutput eco_damOut_yactual annotation (
      Placement(transformation(extent={{236,-168},{256,-148}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression vavHea_Q(y=cor.terHea.Q1_flow)
    annotation (Placement(transformation(extent={{644,506},{664,526}})));
  Modelica.Blocks.Interfaces.RealOutput vavCorHea_Q annotation (Placement(
        transformation(extent={{674,504},{694,524}}), iconTransformation(extent=
           {{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression vavHea_Q1(y=nor.terHea.Q1_flow)
    annotation (Placement(transformation(extent={{644,482},{664,502}})));
  Modelica.Blocks.Interfaces.RealOutput vavNorHea_Q annotation (Placement(
        transformation(extent={{674,482},{694,502}}), iconTransformation(extent=
           {{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression vavHea_Q2(y=sou.terHea.Q1_flow)
    annotation (Placement(transformation(extent={{644,460},{664,480}})));
  Modelica.Blocks.Sources.RealExpression vavHea_Q3(y=eas.terHea.Q1_flow)
    annotation (Placement(transformation(extent={{644,438},{664,458}})));
  Modelica.Blocks.Interfaces.RealOutput vavSouHea_Q annotation (Placement(
        transformation(extent={{674,460},{694,480}}), iconTransformation(extent=
           {{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput vavEasHea_Q annotation (Placement(
        transformation(extent={{674,438},{694,458}}), iconTransformation(extent=
           {{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression vavHea_Q4(y=wes.terHea.Q1_flow)
    annotation (Placement(transformation(extent={{644,416},{664,436}})));
  Modelica.Blocks.Interfaces.RealOutput vavWesHea_Q annotation (Placement(
        transformation(extent={{674,416},{694,436}}), iconTransformation(extent=
           {{350,-140},{370,-120}})));
  UnitConversion.VToCFM vToCFM_ahu3
    annotation (Placement(transformation(extent={{-144,-16},{-128,0}})));
  Modelica.Blocks.Interfaces.RealOutput VExh_flow "Exhaustr air flowrate"
    annotation (Placement(transformation(extent={{-120,-18},{-100,2}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  Modelica.Blocks.Sources.RealExpression modTim(y=time) "Modelica time"
    annotation (Placement(transformation(extent={{1020,728},{1040,748}})));
  Modelica.Blocks.Interfaces.RealOutput modelica_time "Value of Real output"
    annotation (Placement(transformation(extent={{1164,728},{1184,748}}),
        iconTransformation(extent={{180,160},{200,180}})));
  UnitConversion.FromAnalog volToUni_2(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{-120,190},{-102,208}})));
  Modelica.Blocks.Interfaces.RealInput yMinOADam
    "Voltage signal for economizer minimum OA damper position" annotation (
      Placement(transformation(extent={{-150,190},{-132,208}}),
        iconTransformation(extent={{-220,-140},{-200,-120}})));
  Modelica.Blocks.Math.Max max1
    annotation (Placement(transformation(extent={{-94,150},{-74,170}})));
  UnitConversion.KToF kToF_TOut1
    annotation (Placement(transformation(extent={{-246,148},{-226,168}})));
  Modelica.Blocks.Interfaces.RealOutput TWetBul_OA "Outdoor air wet-bulb temp"
    annotation (Placement(transformation(extent={{-220,148},{-200,168}}),
        iconTransformation(extent={{80,-40},{100,-20}})));
  UnitConversion.ToAnolog toV24(
    x_min=0,
    x_max=36000,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{578,-120},{598,-100}})));
  Modelica.Blocks.Interfaces.RealOutput HP_CHW_V "CHW head pressure %"
    annotation (Placement(transformation(extent={{620,-120},{640,-100}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.ToAnolog toV25(
    x_min=0,
    x_max=5.05,
    v_min=0,
    v_max=10) "0/80 gpm"
    annotation (Placement(transformation(extent={{730,-172},{750,-152}})));
  Modelica.Blocks.Interfaces.RealOutput m_CHW_V "CHW flow rate" annotation (
      Placement(transformation(extent={{762,-172},{782,-152}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.KToF kToF11
    annotation (Placement(transformation(extent={{840,-110},{860,-90}})));
  UnitConversion.ToAnolog toV26(
    x_min=39,
    x_max=68,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{872,-110},{892,-90}})));
  Modelica.Blocks.Interfaces.RealOutput T_CHWS_V "CHW Supply Temperature"
    annotation (Placement(transformation(extent={{900,-110},{920,-90}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.KToF kToF15
    annotation (Placement(transformation(extent={{674,-122},{694,-102}})));
  UnitConversion.ToAnolog toV28(
    x_min=39,
    x_max=68,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{700,-122},{720,-102}})));
  Modelica.Blocks.Interfaces.RealOutput T_CHWR_V "CHW Return Temperature"
    annotation (Placement(transformation(extent={{728,-122},{748,-102}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.KToF kToF16
    annotation (Placement(transformation(extent={{548,-290},{568,-270}})));
  UnitConversion.ToAnolog toV29(
    x_min=59,
    x_max=113,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{580,-290},{600,-270}})));
  Modelica.Blocks.Interfaces.RealOutput T_CWR_V "CW Return Temperature"
    annotation (Placement(transformation(extent={{610,-290},{630,-270}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.KToF kToF18
    annotation (Placement(transformation(extent={{788,-274},{808,-254}})));
  UnitConversion.ToAnolog toV30(
    x_min=59,
    x_max=113,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{820,-274},{840,-254}})));
  Modelica.Blocks.Interfaces.RealOutput T_CWS_V "CW Supply Temperature"
    annotation (Placement(transformation(extent={{850,-274},{870,-254}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.KToF kToF19
    annotation (Placement(transformation(extent={{606,-258},{626,-238}})));
  UnitConversion.ToAnolog toV31(
    x_min=59,
    x_max=113,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{638,-258},{658,-238}})));
  Modelica.Blocks.Interfaces.RealOutput T_CWR_beforeWSE_V
    "CW Return Temperature before WSE" annotation (Placement(transformation(
          extent={{668,-258},{688,-238}}), iconTransformation(extent={{350,-120},
            {370,-100}})));
  Modelica.Blocks.Math.RealToBoolean reaToBoo1(threshold=0.1)
    annotation (Placement(transformation(extent={{440,-160},{460,-140}})));
  Modelica.Blocks.Math.BooleanToReal booToRea5
    annotation (Placement(transformation(extent={{470,-160},{490,-140}})));
  UnitConversion.ToAnolog toV32(
    x_min=0,
    x_max=1,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{440,-194},{460,-174}})));
  Modelica.Blocks.Interfaces.RealOutput booCHWval_V "CHW Valve" annotation (
      Placement(transformation(extent={{470,-194},{490,-174}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Math.RealToBoolean reaToBoo2(threshold=0.1)
    annotation (Placement(transformation(extent={{408,-366},{428,-346}})));
  Modelica.Blocks.Math.BooleanToReal booToRea6
    annotation (Placement(transformation(extent={{438,-366},{458,-346}})));
  UnitConversion.ToAnolog toV33(
    x_min=0,
    x_max=1,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{470,-366},{490,-346}})));
  Modelica.Blocks.Interfaces.RealOutput booCWval_V "CW Valve" annotation (
      Placement(transformation(extent={{500,-366},{520,-346}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  UnitConversion.ToAnolog toV34(
    x_min=0,
    x_max=36000,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{534,-218},{554,-198}})));
  Modelica.Blocks.Interfaces.RealOutput dp_WSE_V "WSE differential pressure"
    annotation (Placement(transformation(extent={{562,-218},{582,-198}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.ToAnolog toV35(
    x_min=0,
    x_max=36000,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{524,-256},{544,-236}})));
  Modelica.Blocks.Interfaces.RealOutput dp_Chi_V
    "Chiller differential pressure" annotation (Placement(transformation(extent=
           {{552,-256},{572,-236}}), iconTransformation(extent={{350,-120},{370,
            -100}})));
  UnitConversion.KToF kToF20
    annotation (Placement(transformation(extent={{662,-288},{682,-268}})));
  UnitConversion.ToAnolog toV36(
    x_min=39,
    x_max=68,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{694,-288},{714,-268}})));
  Modelica.Blocks.Interfaces.RealOutput T_CHWR_afterWSE_V
    "CHW Return Temperature after WSE" annotation (Placement(transformation(
          extent={{724,-288},{744,-268}}), iconTransformation(extent={{350,-120},
            {370,-100}})));
  Modelica.Blocks.Math.RealToBoolean reaToBoo3(threshold=0.01)
    annotation (Placement(transformation(extent={{904,-376},{924,-356}})));
  Modelica.Blocks.Math.BooleanToReal booToRea7
    annotation (Placement(transformation(extent={{934,-376},{954,-356}})));
  UnitConversion.ToAnolog toV37(
    x_min=0,
    x_max=1,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{966,-376},{986,-356}})));
  Modelica.Blocks.Interfaces.RealOutput booCWPump_V "CW pump status"
    annotation (Placement(transformation(extent={{1006,-376},{1026,-356}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput booCHWPump_V "CHW pump status"
    annotation (Placement(transformation(extent={{1006,-396},{1026,-376}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Math.RealToBoolean reaToBoo4(threshold=10)
    annotation (Placement(transformation(extent={{742,-378},{762,-358}})));
  Modelica.Blocks.Math.BooleanToReal booToRea8
    annotation (Placement(transformation(extent={{772,-378},{792,-358}})));
  UnitConversion.ToAnolog toV38(
    x_min=0,
    x_max=1,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{804,-378},{824,-358}})));
  Modelica.Blocks.Interfaces.RealOutput booCT_V "CT status" annotation (
      Placement(transformation(extent={{834,-378},{854,-358}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Math.RealToBoolean reaToBoo5(threshold=3)
    annotation (Placement(transformation(extent={{1082,-300},{1102,-280}})));
  Modelica.Blocks.Interfaces.RealInput yChiOn
    "Voltage signal forchiller on/off" annotation (Placement(transformation(
          extent={{1052,-300},{1072,-280}}), iconTransformation(extent={{-220,
            -260},{-200,-240}})));
  UnitConversion.FromAnalog volToUni_yhea6(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{1082,-324},{1094,-312}})));
  Modelica.Blocks.Interfaces.RealInput yCHWPumSpe
    "Voltage signal for CHW pump speed" annotation (Placement(transformation(
          extent={{1048,-332},{1076,-304}}), iconTransformation(extent={{-220,
            -280},{-200,-260}})));
  UnitConversion.FromAnalog volToUni_yhea7(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{1082,-366},{1094,-354}})));
  Modelica.Blocks.Interfaces.RealInput yCWPumSpe
    "Voltage signal for CW pump speed" annotation (Placement(transformation(
          extent={{1048,-374},{1076,-346}}), iconTransformation(extent={{-220,
            -300},{-200,-280}})));
  UnitConversion.FromAnalog volToUni_yhea8(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{1082,-394},{1094,-382}})));
  Modelica.Blocks.Interfaces.RealInput yCTSpe "Voltage signal for CT fan speed"
    annotation (Placement(transformation(extent={{1048,-402},{1076,-374}}),
        iconTransformation(extent={{-220,-320},{-200,-300}})));
  UnitConversion.KToF kToF21
    annotation (Placement(transformation(extent={{1262,-326},{1282,-306}})));
  Modelica.Blocks.Interfaces.RealOutput T_CHWSupSet_F
    "T&R Supply Temperature Setpoint" annotation (Placement(transformation(
          extent={{1292,-326},{1312,-306}}), iconTransformation(extent={{350,-120},
            {370,-100}})));
  Modelica.Blocks.Interfaces.RealOutput dp_CHWSupSet_pa "T&R DP Setpoint"
    annotation (Placement(transformation(extent={{1244,-234},{1264,-214}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  Modelica.Blocks.Sources.RealExpression power1(y=eleChi.y)
    annotation (Placement(transformation(extent={{384,-226},{404,-206}})));
  Modelica.Blocks.Interfaces.RealOutput Power_chiller_V annotation (Placement(
        transformation(extent={{436,-226},{456,-206}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression power2(y=eleCHWP.y)
    annotation (Placement(transformation(extent={{384,-250},{404,-230}})));
  Modelica.Blocks.Interfaces.RealOutput Power_chwPum_V annotation (Placement(
        transformation(extent={{436,-250},{456,-230}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression power3(y=eleCWP.y)
    annotation (Placement(transformation(extent={{384,-272},{404,-252}})));
  Modelica.Blocks.Interfaces.RealOutput Power_cwPum_V annotation (Placement(
        transformation(extent={{436,-272},{456,-252}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression power4(y=eleCT.y)
    annotation (Placement(transformation(extent={{384,-294},{404,-274}})));
  Modelica.Blocks.Interfaces.RealOutput Power_ct_V annotation (Placement(
        transformation(extent={{436,-294},{456,-274}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Sources.RealExpression power5(y=eleSupFan.y + eleChi.y +
        eleCHWP.y + eleCWP.y + eleCT.y)
    annotation (Placement(transformation(extent={{382,-320},{402,-300}})));
  Modelica.Blocks.Interfaces.RealOutput Power_total_V annotation (Placement(
        transformation(extent={{436,-320},{456,-300}}), iconTransformation(
          extent={{350,-140},{370,-120}})));
  UnitConversion.ToAnolog toV39(
    x_min=0,
    x_max=50000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{412,-316},{424,-304}})));
  UnitConversion.ToAnolog toV40(
    x_min=0,
    x_max=8000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{412,-290},{424,-278}})));
  UnitConversion.ToAnolog toV41(
    x_min=0,
    x_max=5000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{412,-268},{424,-256}})));
  UnitConversion.ToAnolog toV42(
    x_min=0,
    x_max=5000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{412,-246},{424,-234}})));
  UnitConversion.ToAnolog toV43(
    x_min=0,
    x_max=30000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{412,-222},{424,-210}})));
  UnitConversion.ToAnolog toV44(
    x_min=0,
    x_max=10000,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{286,-106},{298,-94}})));
equation

  connect(chiWSE.TCHWSupWSE,cooModCon. TCHWSupWSE)
    annotation (Line(
      points={{673,-212},{666,-212},{666,-76},{1016,-76},{1016,-260.444},{1026,
          -260.444}},
      color={0,0,127}));
  connect(towTApp.y,cooModCon. TApp)
    annotation (Line(
      points={{1009,-290},{1018,-290},{1018,-257.111},{1026,-257.111}},
      color={0,0,127}));
  connect(cooModCon.TCHWRetWSE, TCHWRet.T)
    annotation (Line(
      points={{1026,-263.778},{1014,-263.778},{1014,-66},{608,-66},{608,-177}},
    color={0,0,127}));
  connect(cooModCon.y, chiStaCon.cooMod)
    annotation (Line(
      points={{1049,-254.889},{1072,-254.889},{1072,-66},{1270,-66},{1270,-122},
          {1284,-122}},
      color={255,127,0}));
  connect(cooModCon.y,intToBoo.u)
    annotation (Line(
      points={{1049,-254.889},{1072,-254.889},{1072,-66},{1270,-66},{1270,-154},
          {1284,-154}},
      color={255,127,0}));
  connect(cooModCon.y, cooTowSpeCon.cooMod) annotation (Line(points={{1049,
          -254.889},{1072,-254.889},{1072,-66},{1270,-66},{1270,-93.5556},{1284,
          -93.5556}},                                color={255,127,0}));
  connect(cooModCon.y, CWPumCon.cooMod) annotation (Line(points={{1049,-254.889},
          {1072,-254.889},{1072,-66},{1270,-66},{1270,-201},{1282,-201}},
                                          color={255,127,0}));
  connect(yVal5.y, chiWSE.yVal5) annotation (Line(points={{1039,-182},{864,-182},
          {864,-211},{695.6,-211}},
                              color={0,0,127}));
  connect(yVal6.y, chiWSE.yVal6) annotation (Line(points={{1039,-198},{866,-198},
          {866,-207.8},{695.6,-207.8}}, color={0,0,127}));
  connect(watVal.port_a, cooCoi.port_b1) annotation (Line(points={{538,-98},{538,
          -86},{182,-86},{182,-52},{190,-52}},
                           color={0,127,255},
      thickness=0.5));
  connect(cooCoi.port_a1, TCHWSup.port_b) annotation (Line(points={{210,-52},{220,
          -52},{220,-78},{642,-78},{642,-128},{758,-128}},
                                       color={0,127,255},
      thickness=0.5));
  connect(TCWSup.T, cooTowSpeCon.TCWSup) annotation (Line(points={{828,-305},{
          828,-64},{1274,-64},{1274,-100.667},{1284,-100.667}},
        color={0,0,127}));
  connect(TCHWSup.T, cooTowSpeCon.TCHWSup) annotation (Line(points={{768,-117},
          {768,-64},{1272,-64},{1272,-104.222},{1284,-104.222}},
                            color={0,0,127}));
  connect(pumSpe.y, proCHWP.u2) annotation (Line(points={{1361,-248},{1366,-248},
          {1366,-256},{1374,-256}},
                                 color={0,0,127}));
  connect(watVal.y_actual, temDifPreRes.u) annotation (Line(points={{531,-113},{
          530,-113},{530,-122},{518,-122},{518,-72},{964,-72},{964,-244},{1194,-244}},
                                                          color={0,0,127}));
  connect(cooModCon.y, temDifPreRes.uOpeMod) annotation (Line(points={{1049,
          -254.889},{1072,-254.889},{1072,-238},{1194,-238}},
        color={255,127,0}));
  connect(temDifPreRes.TSet, cooModCon.TCHWSupSet) annotation (Line(points={{1217,
          -249},{1218,-249},{1218,-250},{1232,-250},{1232,-70},{1018,-70},{1018,
          -250.222},{1026,-250.222}},
                                    color={0,0,127}));
  connect(TOut.y, chiPlaEnaDis.TOut) annotation (Line(points={{-279,180},{1078,
          180},{1078,-105.4},{1098,-105.4}},
                                         color={0,0,127}));
  connect(booToRea.y, proCHWP.u1) annotation (Line(points={{1189,-116},{1246,-116},
          {1246,-64},{1368,-64},{1368,-244},{1374,-244}},
                  color={0,0,127}));
  connect(booToRea.y, val.y) annotation (Line(points={{1189,-116},{1246,-116},{1246,
          -174},{1420,-174},{1420,-342},{620,-342},{620,-296},{646,-296},{646,-304}},
                                                                  color={0,0,
          127}));
  connect(heaCoi.port_b1, HWVal.port_a)
    annotation (Line(points={{98,-52},{98,-170},{98,-170}},color={238,46,47},
      thickness=0.5));
  connect(boiPlaEnaDis.yPla, booToReaHW.u)
    annotation (Line(points={{-257,-160},{-220,-160}}, color={255,0,255}));
  connect(booToReaHW.y, boiIsoVal.y) annotation (Line(points={{-197,-160},{-182,
          -160},{-182,-360},{242,-360},{242,-300},{292,-300},{292,-308}},
                             color={0,0,127}));
  connect(booToReaHW.y, proPumHW.u1) annotation (Line(points={{-197,-160},{-178,
          -160},{-178,-72},{-98,-72},{-98,-210},{-42,-210},{-42,-308},{-34,-308}},
                                        color={0,0,127}));
  connect(booToReaHW.y, proBoi.u1) annotation (Line(points={{-197,-160},{-184,-160},
          {-184,-82},{-96,-82},{-96,-208},{-40,-208},{-40,-266},{-34,-266}},
                                        color={0,0,127}));
  connect(boiPlaEnaDis.yPla, pumSpeHW.trigger) annotation (Line(points={{-257,-160},
          {-240,-160},{-240,-82},{-92,-82},{-92,-338},{-68,-338},{-68,-332}},
                                                                color={255,0,
          255}));
  connect(boiPlaEnaDis.yPla, minFloBypHW.yPla) annotation (Line(points={{-257,-160},
          {-240,-160},{-240,-80},{-92,-80},{-92,-251},{-76,-251}}, color={255,0,
          255}));
  connect(cooModCon.yPla, pumSpe.trigger) annotation (Line(points={{1026,
          -247.333},{1022,-247.333},{1022,-336},{1342,-336},{1342,-260}}, color=
         {255,0,255}));
  connect(THWSup.port_a, heaCoi.port_a1) annotation (Line(points={{350,-214},{350,
          -140},{142,-140},{142,-52},{118,-52}},     color={238,46,47},
      thickness=0.5));
  connect(wseOn.y, chiWSE.on[2]) annotation (Line(points={{1347,-154},{1408,-154},
          {1408,-338},{866,-338},{866,-215.6},{695.6,-215.6}},
                                                            color={255,0,255}));
  connect(boiPlaEnaDis.yPla, boiTSup.trigger) annotation (Line(points={{-257,-160},
          {-238,-160},{-238,-78},{-92,-78},{-92,-292},{-72,-292},{-72,-290}},
                                                                color={255,0,
          255}));
  connect(plaReqChi.yPlaReq, chiPlaEnaDis.yPlaReq) annotation (Line(points={{1065,
          -102},{1072,-102},{1072,-114},{1098,-114}},      color={255,127,0}));
  connect(swiFreSta.y, plaReqBoi.uPlaVal) annotation (Line(points={{42,-130},{58,
          -130},{58,-70},{-250,-70},{-250,-120},{-340,-120},{-340,-160},{-322,-160}},
                                                                   color={0,0,
          127}));
  connect(minFloBypHW.y, valBypBoi.y) annotation (Line(points={{-53,-248},{-44,-248},
          {-44,-358},{178,-358},{178,-230},{230,-230},{230,-240}},
                                                   color={0,0,127}));
  connect(plaReqBoi.yPlaReq, boiPlaEnaDis.yPlaReq) annotation (Line(points={{-299,
          -160},{-290,-160},{-290,-164},{-280,-164}},      color={255,127,0}));
  connect(boiPlaEnaDis.yPla, triResHW.uDevSta) annotation (Line(points={{-257,-160},
          {-240,-160},{-240,-80},{-182,-80},{-182,-221},{-160,-221}},
                                                      color={255,0,255}));
  connect(TOut.y, boiPlaEnaDis.TOut) annotation (Line(points={{-279,180},{-260,
          180},{-260,-68},{-252,-68},{-252,-118},{-288,-118},{-288,-155.4},{
          -280,-155.4}},
        color={0,0,127}));
  connect(swiFreSta.y, proHWVal.u1) annotation (Line(points={{42,-130},{48,-130},
          {48,-156},{22,-156},{22,-174},{38,-174}}, color={0,0,127}));
  connect(proHWVal.y, HWVal.y)
    annotation (Line(points={{62,-180},{86,-180}}, color={0,0,127}));
  connect(booToReaHW.y, proHWVal.u2) annotation (Line(points={{-197,-160},{-94,-160},
          {-94,-186},{38,-186}}, color={0,0,127}));
  connect(proCHWVal.y, watVal.y)
    annotation (Line(points={{490,-108},{526,-108}}, color={0,0,127}));
  connect(booToRea.y, proCHWVal.u2) annotation (Line(points={{1189,-116},{1228,-116},
          {1228,-74},{436,-74},{436,-114},{466,-114}}, color={0,0,127}));
  connect(fanSup.y_actual, chiPlaEnaDis.yFanSpe) annotation (Line(points={{321,
          -33},{382,-33},{382,-68},{1080,-68},{1080,-117},{1099,-117}}, color={
          0,0,127}));
  connect(fanSup.y_actual, boiPlaEnaDis.yFanSpe) annotation (Line(points={{321,
          -33},{384,-33},{384,28},{16,28},{16,-66},{-256,-66},{-256,-124},{-294,
          -124},{-294,-167},{-279,-167}}, color={0,0,127}));
  connect(minFloBypCHW.m_flow, chiWSE.mCHW_flow) annotation (Line(points={{1038,
          -147},{1012,-147},{1012,-178},{668,-178},{668,-206},{673,-206}},
        color={0,0,127}));
  connect(yVal7.y, chiWSE.yVal7) annotation (Line(points={{1039,-220},{862,-220},
          {862,-200.4},{695.6,-200.4}}, color={0,0,127}));

  connect(CHWSTDelAtt.y, chiWSE.TSet) annotation (Line(points={{1197,-300},{1180,
          -300},{1180,-346},{770,-346},{770,-220},{695.6,-220},{695.6,-218.8}},
        color={235,0,0}));
  connect(CHWSTDelAtt.y, cooTowSpeCon.TCHWSupSet) annotation (Line(points={{1197,
          -300},{1160,-300},{1160,-76},{1268,-76},{1268,-97.1111},{1284,
          -97.1111}},
        color={235,0,0}));
  connect(booToReaHW.y, boiRunTim.u) annotation (Line(points={{-197,-160},{-188,
          -160},{-188,676},{1322,676},{1322,610},{1338,610}}, color={0,0,127}));
  connect(booToReaSupFan.y, supFanRunTim.u) annotation (Line(points={{1241,652},
          {1318,652},{1318,580},{1338,580}}, color={0,0,127}));
  connect(gai.y, CWPRunTim.u) annotation (Line(points={{1347,-206},{1400,-206},
          {1400,460},{1380,460},{1380,610},{1398,610}}, color={0,0,127}));
  connect(proCHWP.u1, CHWPRunTim.u) annotation (Line(points={{1374,-244},{1368,
          -244},{1368,-64},{1400,-64},{1400,460},{1380,460},{1380,640},{1398,
          640}}, color={0,0,127}));
  connect(proPumHW.u1, HWPRunTim.u) annotation (Line(points={{-34,-308},{-42,
          -308},{-42,-206},{-48,-206},{-48,678},{1382,678},{1382,580},{1398,580}},
        color={0,0,127}));
  connect(greaterEqualThreshold.y, booToReaCT.u)
    annotation (Line(points={{1241,698},{1252,698}}, color={255,0,255}));
  connect(booToReaCT.y, cooTowRunTim.u) annotation (Line(points={{1275,698},{
          1316,698},{1316,550},{1338,550}}, color={0,0,127}));
  connect(cooTowSpeCon.y, greaterEqualThreshold.u) annotation (Line(points={{1307,
          -97.1111},{1400,-97.1111},{1400,460},{1378,460},{1378,680},{1200,680},
          {1200,698},{1218,698}},      color={0,0,127}));
  connect(chiOnAtt.y, chiRunTim.u) annotation (Line(points={{1371,-110},{1378,
          -110},{1378,674},{1324,674},{1324,640},{1338,640}}, color={235,0,0}));
  connect(chiWSE.on[1], sigChaChi.u) annotation (Line(points={{695.6,-215.6},{
          868,-215.6},{868,-338},{1438,-338},{1438,660},{1458,660}}, color={255,
          0,255}));
  connect(boiPlaEnaDis.yPla, sigChaBoi.u) annotation (Line(points={{-257,-160},
          {-240,-160},{-240,-372},{1440,-372},{1440,610},{1458,610}}, color={
          255,0,255}));
  connect(sigChaChi.u, sigChaCooTow.u) annotation (Line(points={{1458,660},{
          1442,660},{1442,510},{1458,510}}, color={255,0,255}));
  connect(sigChaCooTow.u, sigChaCHWP.u) annotation (Line(points={{1458,510},{
          1446,510},{1446,460},{1458,460}}, color={255,0,255}));
  connect(sigChaCHWP.u, sigChaCWP.u) annotation (Line(points={{1458,460},{1446,
          460},{1446,400},{1458,400}}, color={255,0,255}));
  connect(sigChaBoi.u, sigChaHWP.u) annotation (Line(points={{1458,610},{1446,
          610},{1446,350},{1458,350}}, color={255,0,255}));
  connect(flo.TRooAir[1], kToF1.K) annotation (Line(points={{1094.14,488.4},{
          1086,488.4},{1086,710},{1098,710}},
                                         color={0,0,127}));
  connect(kToF1.F, toV1.x)
    annotation (Line(points={{1121,710},{1130,710}}, color={0,0,127}));
  connect(toV1.v, TRooAirSou_V)
    annotation (Line(points={{1153,710},{1174,710}}, color={0,0,127}));
  connect(reaTDryBul.y, TOut.u) annotation (Line(points={{-369,156},{-312,156},
          {-312,180},{-302,180}}, color={0,0,127}));
  connect(chicago.weaBus, amb.weaBus) annotation (Line(
      points={{-342.2,180.2},{-332,180.2},{-332,-44.78},{-136,-44.78}},
      color={255,204,51},
      thickness=0.5));
  connect(reaTDryBul.y, wetBul.TDryBul) annotation (Line(points={{-369,156},{
          -348,156},{-348,118},{-301,118}}, color={0,0,127}));
  connect(reaRH.y, wetBul.phi) annotation (Line(points={{-369,136},{-366,136},{
          -366,110},{-301,110}}, color={0,0,127}));
  connect(reaPre.y, wetBul.p)
    annotation (Line(points={{-369,102},{-301,102}}, color={0,0,127}));
  connect(reaTDryBul.y, cooTow.TAir) annotation (Line(points={{-369,156},{-326,
          156},{-326,-380},{720,-380},{720,-312},{736,-312}}, color={0,0,127}));
  connect(wetBul.TWetBul, cooModCon.TWetBul) annotation (Line(points={{-279,110},
          {280,110},{280,-82},{994,-82},{994,-253.778},{1026,-253.778}}, color=
          {0,0,127}));
  connect(yHeaCor, volToUni_yhea1.v)
    annotation (Line(points={{468,28},{486.8,28}}, color={0,0,127}));
  connect(volToUni_yhea1.y, cor.yVal)
    annotation (Line(points={{500.6,28},{566,28},{566,34}}, color={0,0,127}));
  connect(kToF2.F,toV2. x)
    annotation (Line(points={{1121,682},{1124,682},{1124,684},{1126,684},{1126,
          682},{1130,682}},                          color={0,0,127}));
  connect(toV2.v, TRooAirEas_V)
    annotation (Line(points={{1153,682},{1174,682}}, color={0,0,127}));
  connect(kToF3.F,toV3. x)
    annotation (Line(points={{1121,630},{1130,630}}, color={0,0,127}));
  connect(toV3.v, TRooAirNor_V)
    annotation (Line(points={{1153,630},{1174,630}}, color={0,0,127}));
  connect(kToF4.F,toV4. x)
    annotation (Line(points={{1121,600},{1130,600}}, color={0,0,127}));
  connect(toV4.v, TRooAirWes_V)
    annotation (Line(points={{1153,600},{1174,600}}, color={0,0,127}));
  connect(kToF5.F,toV5. x)
    annotation (Line(points={{1121,560},{1130,560}}, color={0,0,127}));
  connect(toV5.v, TRooAirCor_V)
    annotation (Line(points={{1153,560},{1174,560}}, color={0,0,127}));
  connect(flo.TRooAir[2], kToF2.K) annotation (Line(points={{1094.14,489.867},{
          1094.14,586},{1094,586},{1094,682},{1098,682}}, color={0,0,127}));
  connect(flo.TRooAir[3], kToF3.K) annotation (Line(points={{1094.14,491.333},{
          1094.14,560},{1094,560},{1094,630},{1098,630}}, color={0,0,127}));
  connect(flo.TRooAir[4], kToF4.K) annotation (Line(points={{1094.14,492.8},{
          1094.14,600},{1098,600}}, color={0,0,127}));
  connect(flo.TRooAir[5], kToF5.K) annotation (Line(points={{1094.14,494.267},{
          1094.14,528},{1094,528},{1094,560},{1098,560}}, color={0,0,127}));
  connect(vToCFM_vav1.CFM, toV6.x)
    annotation (Line(points={{521,342},{528,342}}, color={0,0,127}));
  connect(toV6.v, VCor_flow_V)
    annotation (Line(points={{551,342},{568,342}}, color={0,0,127}));
  connect(VSupCor_flow.V_flow, vToCFM_vav1.V_flow) annotation (Line(points={{
          569,130},{484,130},{484,342},{498,342}}, color={0,0,127}));
  connect(vToCFM_vav2.CFM, toV7.x)
    annotation (Line(points={{693,340},{700,340}}, color={0,0,127}));
  connect(toV7.v, VSou_flow_V)
    annotation (Line(points={{723,340},{744,340}}, color={0,0,127}));
  connect(VSupSou_flow.V_flow, vToCFM_vav2.V_flow) annotation (Line(points={{
          749,130},{658,130},{658,340},{670,340}}, color={0,0,127}));
  connect(vToCFM_vav3.CFM, toV8.x)
    annotation (Line(points={{905,340},{912,340}}, color={0,0,127}));
  connect(toV8.v, VEas_flow_V)
    annotation (Line(points={{935,340},{956,340}}, color={0,0,127}));
  connect(VSupEas_flow.V_flow, vToCFM_vav3.V_flow) annotation (Line(points={{
          929,128},{848,128},{848,340},{882,340}}, color={0,0,127}));
  connect(vToCFM_vav4.CFM, toV9.x)
    annotation (Line(points={{1063,340},{1070,340}}, color={0,0,127}));
  connect(toV9.v, VNor_flow_V) annotation (Line(points={{1093,340},{1102,340},{
          1102,340},{1116,340}}, color={0,0,127}));
  connect(VSupNor_flow.V_flow, vToCFM_vav4.V_flow) annotation (Line(points={{
          1089,132},{1042,132},{1042,338},{1040,338},{1040,340}}, color={0,0,
          127}));
  connect(vToCFM_vav5.CFM, toV10.x)
    annotation (Line(points={{1227,342},{1234,342}}, color={0,0,127}));
  connect(toV10.v, VWes_flow_V)
    annotation (Line(points={{1257,342},{1278,342}}, color={0,0,127}));
  connect(VSupWes_flow.V_flow, vToCFM_vav5.V_flow) annotation (Line(points={{
          1289,128},{1196,128},{1196,342},{1204,342}}, color={0,0,127}));
  connect(kToF6.F, toV11.x)
    annotation (Line(points={{521,280},{528,280}}, color={0,0,127}));
  connect(toV11.v, TDisCor_V)
    annotation (Line(points={{551,280},{570,280}}, color={0,0,127}));
  connect(TSupCor.T, kToF6.K) annotation (Line(points={{569,92},{476,92},{476,
          280},{498,280}}, color={0,0,127}));
  connect(toV12.v, TDisSou_V)
    annotation (Line(points={{725,280},{744,280}}, color={0,0,127}));
  connect(kToF7.F, toV12.x) annotation (Line(points={{691,280},{696,280},{696,
          280},{702,280}}, color={0,0,127}));
  connect(TSupSou.T, kToF7.K) annotation (Line(points={{749,92},{666,92},{666,
          280},{668,280}}, color={0,0,127}));
  connect(toV13.v, TDisEas_V)
    annotation (Line(points={{937,280},{956,280}}, color={0,0,127}));
  connect(kToF8.F, toV13.x)
    annotation (Line(points={{907,280},{914,280}}, color={0,0,127}));
  connect(TSupEas.T, kToF8.K) annotation (Line(points={{929,90},{876,90},{876,
          280},{884,280}}, color={0,0,127}));
  connect(kToF9.F, toV14.x)
    annotation (Line(points={{1073,280},{1080,280}}, color={0,0,127}));
  connect(toV14.v, TDisNor_V)
    annotation (Line(points={{1103,280},{1122,280}}, color={0,0,127}));
  connect(TSupNor.T, kToF9.K) annotation (Line(points={{1089,94},{1048,94},{
          1048,280},{1050,280}}, color={0,0,127}));
  connect(kToF10.F, toV15.x)
    annotation (Line(points={{1233,280},{1240,280}}, color={0,0,127}));
  connect(toV15.v, TDisWes_V)
    annotation (Line(points={{1263,280},{1280,280}}, color={0,0,127}));
  connect(TSupWes.T, kToF10.K) annotation (Line(points={{1289,90},{1210,90},{
          1210,280}}, color={0,0,127}));
  connect(yVAVCor, volToUni_yvav1.v) annotation (Line(points={{-186,-46},{256,
          -46},{256,60},{486.8,60}}, color={0,0,127}));
  connect(volToUni_yvav1.y, cor.yVAV)
    annotation (Line(points={{500.6,60},{566,60},{566,50}}, color={0,0,127}));
  connect(yHeaSou, volToUni_yhea2.v)
    annotation (Line(points={{640,28},{658.8,28}}, color={0,0,127}));
  connect(yVAVSou, volToUni_yvav2.v)
    annotation (Line(points={{640,60},{658.8,60}}, color={0,0,127}));
  connect(volToUni_yvav2.y, sou.yVAV)
    annotation (Line(points={{672.6,60},{746,60},{746,48}}, color={0,0,127}));
  connect(volToUni_yhea2.y, sou.yVal)
    annotation (Line(points={{672.6,28},{746,28},{746,32}}, color={0,0,127}));
  connect(yHeaEas, volToUni_yhea3.v)
    annotation (Line(points={{824,28},{842.8,28}}, color={0,0,127}));
  connect(yVAVEas, volToUni_yvav3.v)
    annotation (Line(points={{824,60},{842.8,60}}, color={0,0,127}));
  connect(yHeaNor, volToUni_yhea4.v)
    annotation (Line(points={{984,28},{1002.8,28}}, color={0,0,127}));
  connect(yVAVNor, volToUni_yvav4.v)
    annotation (Line(points={{984,60},{1002.8,60}}, color={0,0,127}));
  connect(volToUni_yvav3.y, eas.yVAV)
    annotation (Line(points={{856.6,60},{926,60},{926,48}}, color={0,0,127}));
  connect(volToUni_yhea3.y, eas.yVal)
    annotation (Line(points={{856.6,28},{926,28},{926,32}}, color={0,0,127}));
  connect(volToUni_yvav4.y, nor.yVAV) annotation (Line(points={{1016.6,60},{
          1086,60},{1086,48}}, color={0,0,127}));
  connect(volToUni_yhea4.y, nor.yVal) annotation (Line(points={{1016.6,28},{
          1086,28},{1086,32}}, color={0,0,127}));
  connect(yHeaWes, volToUni_yhea5.v)
    annotation (Line(points={{1164,28},{1182.8,28}}, color={0,0,127}));
  connect(yVAVWes, volToUni_yvav5.v)
    annotation (Line(points={{1164,60},{1182.8,60}}, color={0,0,127}));
  connect(volToUni_yvav5.y, wes.yVAV) annotation (Line(points={{1196.6,60},{
          1286,60},{1286,48}}, color={0,0,127}));
  connect(volToUni_yhea5.y, wes.yVal) annotation (Line(points={{1196.6,28},{
          1218,28},{1218,24},{1286,24},{1286,32}}, color={0,0,127}));
  connect(kToF6.F, TDisCor) annotation (Line(points={{521,280},{560,280},{560,
          254},{606,254}}, color={0,0,127}));
  connect(vToCFM_vav1.CFM, VCor_flow) annotation (Line(points={{521,342},{560,
          342},{560,396},{606,396}}, color={0,0,127}));
  connect(kToF7.F, TDisSou) annotation (Line(points={{691,280},{734.5,280},{
          734.5,250},{788,250}}, color={0,0,127}));
  connect(vToCFM_vav2.CFM, VSou_flow) annotation (Line(points={{693,340},{728.5,
          340},{728.5,402},{770,402}}, color={0,0,127}));
  connect(kToF8.F, TDisEas) annotation (Line(points={{907,280},{932,280},{932,
          254},{964,254}}, color={0,0,127}));
  connect(vToCFM_vav3.CFM, VEas_flow) annotation (Line(points={{905,340},{934,
          340},{934,324},{972,324}}, color={0,0,127}));
  connect(kToF9.F, TDisNor) annotation (Line(points={{1073,280},{1096,280},{
          1096,246},{1124,246}}, color={0,0,127}));
  connect(vToCFM_vav4.CFM, VNor_flow) annotation (Line(points={{1063,340},{
          1092.5,340},{1092.5,372},{1132,372}}, color={0,0,127}));
  connect(kToF10.F, TDisWes) annotation (Line(points={{1233,280},{1261.5,280},{
          1261.5,234},{1298,234}}, color={0,0,127}));
  connect(vToCFM_vav5.CFM, VWes_flow) annotation (Line(points={{1227,342},{1227,
          380},{1298,380},{1298,420}}, color={0,0,127}));
  connect(kToF1.F, TRooAirSou) annotation (Line(points={{1121,710},{1046,710},{
          1046,714},{978,714}}, color={0,0,127}));
  connect(kToF2.F, TRooAirEas) annotation (Line(points={{1121,682},{1046.5,682},
          {1046.5,688},{978,688}}, color={0,0,127}));
  connect(kToF3.F, TRooAirNor) annotation (Line(points={{1121,630},{1047.5,630},
          {1047.5,650},{980,650}}, color={0,0,127}));
  connect(kToF4.F, TRooAirWes) annotation (Line(points={{1121,600},{1050,600},{
          1050,606},{982,606}}, color={0,0,127}));
  connect(kToF5.F, TRooAirCor) annotation (Line(points={{1121,560},{1050.5,560},
          {1050.5,580},{984,580}}, color={0,0,127}));
  connect(kToF_TOut.F,TOutAir)  annotation (Line(points={{-335,280},{-332,280},
          {-332,340},{-320,340}},color={0,0,127}));
  connect(gain.y,RHOut)  annotation (Line(points={{-335,246},{-330,246},{-330,
          320},{-320,320}},
                       color={0,0,127}));
  connect(reaTDryBul.y, kToF_TOut.K) annotation (Line(points={{-369,156},{-369,
          280},{-358,280}}, color={0,0,127}));
  connect(reaRH.y, gain.u) annotation (Line(points={{-369,136},{-366,136},{-366,
          246},{-358,246}}, color={0,0,127}));
  connect(toV_TOut.v,TOut_V)
    annotation (Line(points={{-291,280},{-272,280}}, color={0,0,127}));
  connect(toV_RHOut.v,RHOut_V)
    annotation (Line(points={{-291,246},{-272,246}}, color={0,0,127}));
  connect(gain.y, toV_RHOut.x)
    annotation (Line(points={{-335,246},{-314,246}}, color={0,0,127}));
  connect(kToF_TOut.F, toV_TOut.x)
    annotation (Line(points={{-335,280},{-314,280}}, color={0,0,127}));
  connect(booToRea1.y, booOcc)
    annotation (Line(points={{-291,-18},{-274,-18}}, color={0,0,127}));
  connect(occSch.occupied, booToRea1.u) annotation (Line(points={{-297,-76},{
          -294,-76},{-294,-34},{-314,-34},{-314,-18}}, color={255,0,255}));
  connect(booToRea2.y, booSupFan)
    annotation (Line(points={{483,692},{500,692}}, color={0,0,127}));
  connect(conAHU.yHea, yHeaCoi_deb) annotation (Line(points={{424,554.667},{590,
          554.667},{590,510},{606,510}}, color={0,0,127}));
  connect(conAHU.yCoo, yCooCoi_deb) annotation (Line(points={{424,544},{512,544},
          {512,486},{606,486}}, color={0,0,127}));
  connect(conAHU.ySupFanSpe, ySupFanSpe_deb) annotation (Line(points={{424,
          618.667},{448,618.667},{448,642},{554,642}},
                                              color={0,0,127}));
  connect(TCHWSup.T, TCHWSup_K) annotation (Line(points={{768,-117},{780,-117},{
          780,-102},{798,-102}}, color={0,0,127}));
  connect(TCHWRet.T, TCHWRet_K) annotation (Line(points={{608,-177},{618,-177},{
          618,-160},{636,-160}}, color={0,0,127}));
  connect(THWRet.T, THWRet_K) annotation (Line(points={{87,-226},{80,-226},{80,-148},
          {136,-148},{136,-160}}, color={0,0,127}));
  connect(THWSup.T, THWSup_K) annotation (Line(points={{339,-224},{326,-224},{326,
          -166},{406,-166},{406,-170}}, color={0,0,127}));
  connect(senHWFlo.m_flow, mHW_SI) annotation (Line(points={{87,-278},{86,-278},
          {86,-260},{134,-260},{134,-266}}, color={0,0,127}));
  connect(chiWSE.mCHW_flow, mCHW_SI) annotation (Line(points={{673,-206},{670,
          -206},{670,-150},{690,-150}},      color={0,0,127}));
  connect(ySupFanOn,reaToBoo. u)
    annotation (Line(points={{360,710},{378,710}}, color={0,0,127}));
  connect(reaToBoo.y, booToRea2.u) annotation (Line(points={{401,710},{460,710},
          {460,692}}, color={255,0,255}));
  connect(reaToBoo.y, booToReaSupFan.u) annotation (Line(points={{401,710},{810,
          710},{810,652},{1218,652}}, color={255,0,255}));
  connect(reaToBoo.y, chiPlaEnaDis.ySupFan) annotation (Line(points={{401,710},
          {750,710},{750,-110},{1098,-110}},color={255,0,255}));
  connect(reaToBoo.y, boiPlaEnaDis.ySupFan) annotation (Line(points={{401,710},{
          408,710},{408,668},{-284,668},{-284,-160},{-280,-160}}, color={255,0,255}));
  connect(reaToBoo.y, andFreSta.u2) annotation (Line(points={{401,710},{408,710},
          {408,666},{-34,666},{-34,-138},{-22,-138}}, color={255,0,255}));
  connect(reaToBoo.y, sigChaFan.u) annotation (Line(points={{401,710},{930,710},
          {930,560},{1458,560}}, color={255,0,255}));
  connect(ySupFanSpe, volToUni_6.v) annotation (Line(points={{479,623},{479,622},
          {510.2,622},{510.2,621}}, color={0,0,127}));
  connect(volToUni_6.y, fanSup.y) annotation (Line(points={{530.9,621},{530.9,570},
          {530,570},{530,382},{396,382},{396,-16},{310,-16},{310,-28}}, color={0,
          0,127}));
  connect(yCooVal,volToUni_1. v)
    annotation (Line(points={{391,399},{406.2,399}}, color={0,0,127}));
  connect(volToUni_1.y, proCHWVal.u1) annotation (Line(points={{426.9,399},{426.9,
          -102},{466,-102}}, color={0,0,127}));
  connect(volToUni_1.y, plaReqChi.uPlaVal) annotation (Line(points={{426.9,399},
          {426.9,-58},{1038,-58},{1038,-102},{1042,-102}}, color={0,0,127}));
  connect(yHeaVal, volToUni_7.v) annotation (Line(points={{-33,-159},{-26.5,-159},
          {-26.5,-159},{-19.8,-159}}, color={0,0,127}));
  connect(volToUni_7.y, swiFreSta.u3) annotation (Line(points={{0.9,-159},{18,
          -159},{18,-138}}, color={0,0,127}));
  connect(yExhDam,volToUni_3. v)
    annotation (Line(points={{-127,123},{-107.8,123}},
                                                  color={0,0,127}));
  connect(yEcoOADam,volToUni_5. v)
    annotation (Line(points={{-141,155},{-121.8,155}},
                                                   color={0,0,127}));
  connect(yRetAirDam,volToUni_4. v)
    annotation (Line(points={{-127,89},{-107.8,89}}, color={0,0,127}));
  connect(volToUni_3.y, eco.yExh)
    annotation (Line(points={{-87.1,123},{-3,123},{-3,-34}},
                                                           color={0,0,127}));
  connect(volToUni_4.y, eco.yRet) annotation (Line(points={{-87.1,89},{-16.8,89},
          {-16.8,-34}},      color={0,0,127}));
  connect(kToF14.F,toV16. x)
    annotation (Line(points={{331,82},{336,82}}, color={0,0,127}));
  connect(toV16.v,TSup_V)
    annotation (Line(points={{359,82},{376,82}}, color={0,0,127}));
  connect(kToF14.F, TSup_ahu1) annotation (Line(points={{331,82},{332,82},{332,
          106},{346,106}}, color={0,0,127}));
  connect(toV16.v, CCLT_V) annotation (Line(points={{359,82},{362,82},{362,68},
          {376,68}}, color={0,0,127}));
  connect(TSup.T, kToF14.K) annotation (Line(points={{340,-29},{340,46},{306,46},
          {306,82},{308,82}}, color={0,0,127}));
  connect(kToF17.F,toV27. x)
    annotation (Line(points={{197,56},{200,56}}, color={0,0,127}));
  connect(toV27.v,HCLT_V)
    annotation (Line(points={{223,56},{242,56}},   color={0,0,127}));
  connect(kToF17.F, HCLT) annotation (Line(points={{197,56},{197,72},{198,72},{
          198,86},{210,86}}, color={0,0,127}));
  connect(toV27.v, CCET_V) annotation (Line(points={{223,56},{223,72},{226,72},
          {226,86},{238,86}}, color={0,0,127}));
  connect(THeaCoo.T, kToF17.K)
    annotation (Line(points={{150,-29},{150,56},{174,56}}, color={0,0,127}));
  connect(kToF12.F,toV17. x)
    annotation (Line(points={{53,42},{58,42}}, color={0,0,127}));
  connect(toV17.v,TMix_V)
    annotation (Line(points={{81,42},{104,42}},  color={0,0,127}));
  connect(kToF12.F,TMix_ahu)
    annotation (Line(points={{53,42},{53,64},{74,64}}, color={0,0,127}));
  connect(toV17.v,HCET_V)  annotation (Line(points={{81,42},{88,42},{88,24},{
          104,24}},  color={0,0,127}));
  connect(TMix.T, kToF12.K)
    annotation (Line(points={{40,-29},{30,-29},{30,42}}, color={0,0,127}));
  connect(kToF13.F,toV22. x)
    annotation (Line(points={{45,208},{50,208}},
                                               color={0,0,127}));
  connect(toV22.v,TRet_ahu_V)
    annotation (Line(points={{73,208},{86,208}}, color={0,0,127}));
  connect(kToF13.F,TRet_ahu)  annotation (Line(points={{45,208},{48,208},{48,
          236},{58,236}},
                     color={0,0,127}));
  connect(TRet.T, kToF13.K) annotation (Line(points={{100,151},{24,151},{24,174},
          {22,174},{22,208}}, color={0,0,127}));
  connect(vToCFM_ahu.CFM,toV18. x)
    annotation (Line(points={{-137.2,24},{-125.8,24}},
                                                   color={0,0,127}));
  connect(vToCFM_ahu.CFM,VOut_flow)  annotation (Line(points={{-137.2,24},{
          -137.2,40},{-122,40}},          color={0,0,127}));
  connect(toV18.v,VOut_flow_V)
    annotation (Line(points={{-105.1,24},{-86,24}},  color={0,0,127}));
  connect(VOut1.V_flow, vToCFM_ahu.V_flow) annotation (Line(points={{-61,-20.9},
          {-155.6,-20.9},{-155.6,24}}, color={0,0,127}));
  connect(vToCFM_ahu1.CFM,toV21. x)
    annotation (Line(points={{325,250},{332,250}}, color={0,0,127}));
  connect(vToCFM_ahu1.CFM,VRet_flow)  annotation (Line(points={{325,250},{325,
          286},{340,286}},      color={0,0,127}));
  connect(toV21.v,VRet_flow_V)  annotation (Line(points={{355,250},{376,250}},
                                 color={0,0,127}));
  connect(senRetFlo.V_flow, vToCFM_ahu1.V_flow)
    annotation (Line(points={{350,151},{302,151},{302,250}}, color={0,0,127}));
  connect(paTopsi_ahu.PSI, toV19.x)
    annotation (Line(points={{205,160},{212,160}}, color={0,0,127}));
  connect(toV19.v, dpDisSupFan_V)
    annotation (Line(points={{235,160},{252,160}}, color={0,0,127}));
  connect(toV19.v, dpDisSupFan_ahu) annotation (Line(points={{235,160},{238,160},
          {238,128},{254,128}}, color={0,0,127}));
  connect(dpDisSupFan.p_rel, paTopsi_ahu.Pa) annotation (Line(points={{311,0},{
          168,0},{168,160},{182,160}}, color={0,0,127}));
  connect(booToRea2.y, toV20.x) annotation (Line(points={{483,692},{483,707},{
          488,707},{488,724}}, color={0,0,127}));
  connect(toV20.v, booSupFan_V)
    annotation (Line(points={{511,724},{538,724}}, color={0,0,127}));
  connect(toV20.v, booRetFan_V) annotation (Line(points={{511,724},{522,724},{
          522,698},{540,698}}, color={0,0,127}));
  connect(booToRea3.y, booChiPla_deb)
    annotation (Line(points={{1121,-158},{1138,-158}}, color={0,0,127}));
  connect(chiPlaEnaDis.yPla, booToRea3.u) annotation (Line(points={{1121,-110},
          {1121,-142},{1098,-142},{1098,-158}}, color={255,0,255}));
  connect(vToCFM_ahu2.CFM,toV23. x)
    annotation (Line(points={{359,-114},{366,-114}},
                                                 color={0,0,127}));
  connect(toV23.v, VSup_ahu_V)
    annotation (Line(points={{389,-114},{406,-114}}, color={0,0,127}));
  connect(vToCFM_ahu2.CFM, VSup_ahu) annotation (Line(points={{359,-114},{360,
          -114},{360,-138},{372,-138}}, color={0,0,127}));
  connect(senSupFlo.V_flow, vToCFM_ahu2.V_flow) annotation (Line(points={{410,
          -29},{402,-29},{402,-28},{392,-28},{392,-72},{336,-72},{336,-114}},
        color={0,0,127}));
  connect(booToRea4.y, booChiPla)
    annotation (Line(points={{1121,-196},{1138,-196}}, color={0,0,127}));
  connect(booToRea.u, chiPlaEnaDis.ySupFan) annotation (Line(points={{1166,-116},
          {1134,-116},{1134,-86},{1088,-86},{1088,-110},{1098,-110}}, color={
          255,0,255}));
  connect(minFloBypCHW.yPla, chiPlaEnaDis.ySupFan) annotation (Line(points={{
          1038,-153},{1038,-110},{1098,-110}}, color={255,0,255}));
  connect(cooModCon.yPla, chiPlaEnaDis.ySupFan) annotation (Line(points={{1026,
          -247.333},{1026,-110},{1098,-110}}, color={255,0,255}));
  connect(booToRea4.u, chiPlaEnaDis.ySupFan) annotation (Line(points={{1098,
          -196},{1078,-196},{1078,-110},{1098,-110}}, color={255,0,255}));
  connect(cooCoiQFlow.y, cooCoi_Q1)
    annotation (Line(points={{227,-108},{246,-108}}, color={0,0,127}));
  connect(heaCoiQFlow.y, heaCoi_Q1)
    annotation (Line(points={{227,-126},{246,-126}}, color={0,0,127}));
  connect(watVal.y_actual, watVal_yactual) annotation (Line(points={{531,-113},
          {531,-126},{498,-126},{498,-140},{514,-140}}, color={0,0,127}));
  connect(damOut.y, eco_damOut_yactual)
    annotation (Line(points={{227,-158},{246,-158}}, color={0,0,127}));
  connect(vavHea_Q.y, vavCorHea_Q)
    annotation (Line(points={{665,516},{674,516},{674,514},{684,514}},
                                                   color={0,0,127}));
  connect(vavHea_Q1.y, vavNorHea_Q)
    annotation (Line(points={{665,492},{684,492}}, color={0,0,127}));
  connect(vavHea_Q2.y, vavSouHea_Q)
    annotation (Line(points={{665,470},{684,470}}, color={0,0,127}));
  connect(vavHea_Q3.y, vavEasHea_Q)
    annotation (Line(points={{665,448},{684,448}}, color={0,0,127}));
  connect(vavHea_Q4.y, vavWesHea_Q)
    annotation (Line(points={{665,426},{684,426}}, color={0,0,127}));
  connect(vToCFM_ahu3.CFM, VExh_flow) annotation (Line(points={{-127.2,-8},{
          -122.6,-8},{-122.6,-8},{-110,-8}}, color={0,0,127}));
  connect(VExh.V_flow, vToCFM_ahu3.V_flow) annotation (Line(points={{-81,-38.9},
          {-81,-26},{-158,-26},{-158,-8},{-145.6,-8}}, color={0,0,127}));
  connect(modTim.y, modelica_time) annotation (Line(points={{1041,738},{1106,
          738},{1106,738},{1174,738}}, color={0,0,127}));
  connect(yMinOADam, volToUni_2.v) annotation (Line(points={{-141,199},{-130.5,
          199},{-130.5,199},{-121.8,199}}, color={0,0,127}));
  connect(volToUni_2.y, max1.u1) annotation (Line(points={{-101.1,199},{-101.1,
          200},{-96,200},{-96,166}}, color={0,0,127}));
  connect(volToUni_5.y, max1.u2) annotation (Line(points={{-101.1,155},{-95.55,
          155},{-95.55,154},{-96,154}}, color={0,0,127}));
  connect(max1.y, eco.yOut)
    annotation (Line(points={{-73,160},{-10,160},{-10,-34}}, color={0,0,127}));
  connect(wetBul.TWetBul, kToF_TOut1.K) annotation (Line(points={{-279,110},{
          -279,134},{-248,134},{-248,158}}, color={0,0,127}));
  connect(kToF_TOut1.F, TWetBul_OA)
    annotation (Line(points={{-225,158},{-210,158}}, color={0,0,127}));
  connect(senRelPre.p_rel, toV24.x) annotation (Line(points={{568,-131},{572,
          -131},{572,-110},{576,-110}}, color={0,0,127}));
  connect(toV24.v,HP_CHW_V)
    annotation (Line(points={{599,-110},{630,-110}}, color={0,0,127}));
  connect(toV25.v, m_CHW_V)
    annotation (Line(points={{751,-162},{772,-162}}, color={0,0,127}));
  connect(kToF11.F, toV26.x)
    annotation (Line(points={{861,-100},{870,-100}}, color={0,0,127}));
  connect(TCHWSup.T, kToF11.K) annotation (Line(points={{768,-117},{804,-117},{
          804,-100},{838,-100}}, color={0,0,127}));
  connect(toV26.v, T_CHWS_V) annotation (Line(points={{893,-100},{896,-100},{
          896,-100},{910,-100}}, color={0,0,127}));
  connect(toV28.x, toV28.x)
    annotation (Line(points={{698,-112},{698,-112}}, color={0,0,127}));
  connect(kToF15.F, toV28.x)
    annotation (Line(points={{695,-112},{698,-112}}, color={0,0,127}));
  connect(toV28.v, T_CHWR_V)
    annotation (Line(points={{721,-112},{738,-112}}, color={0,0,127}));
  connect(TCHWRet.T, kToF15.K) annotation (Line(points={{608,-177},{640,-177},{
          640,-112},{672,-112}}, color={0,0,127}));
  connect(chiWSE.mCHW_flow, toV25.x) annotation (Line(points={{673,-206},{670.5,
          -206},{670.5,-162},{728,-162}}, color={0,0,127}));
  connect(kToF16.F, toV29.x)
    annotation (Line(points={{569,-280},{578,-280}}, color={0,0,127}));
  connect(TCWRet.T, kToF16.K) annotation (Line(points={{544,-305},{546,-305},{
          546,-280}}, color={0,0,127}));
  connect(toV29.v, T_CWR_V) annotation (Line(points={{601,-280},{607.5,-280},{
          607.5,-280},{620,-280}}, color={0,0,127}));
  connect(kToF18.F, toV30.x)
    annotation (Line(points={{809,-264},{818,-264}}, color={0,0,127}));
  connect(toV30.v, T_CWS_V)
    annotation (Line(points={{841,-264},{860,-264}}, color={0,0,127}));
  connect(TCWSup.T, kToF18.K) annotation (Line(points={{828,-305},{786,-305},{
          786,-264}}, color={0,0,127}));
  connect(kToF19.F,toV31. x)
    annotation (Line(points={{627,-248},{636,-248}}, color={0,0,127}));
  connect(toV31.v, T_CWR_beforeWSE_V)
    annotation (Line(points={{659,-248},{678,-248}}, color={0,0,127}));
  connect(chiWSE.TCWRetWSE, kToF19.K) annotation (Line(points={{673,-212},{594,
          -212},{594,-248},{604,-248}}, color={0,0,127}));
  connect(reaToBoo1.y, booToRea5.u)
    annotation (Line(points={{461,-150},{468,-150}}, color={255,0,255}));
  connect(watVal.y_actual, reaToBoo1.u) annotation (Line(points={{531,-113},{
          512,-113},{512,-114},{492,-114},{492,-132},{432,-132},{432,-150},{438,
          -150}}, color={0,0,127}));
  connect(booToRea5.y, toV32.x) annotation (Line(points={{491,-150},{494,-150},
          {494,-166},{434,-166},{434,-184},{438,-184}}, color={0,0,127}));
  connect(toV32.v, booCHWval_V)
    annotation (Line(points={{461,-184},{480,-184}}, color={0,0,127}));
  connect(reaToBoo2.y, booToRea6.u)
    annotation (Line(points={{429,-356},{436,-356}}, color={255,0,255}));
  connect(toV33.v, booCWval_V)
    annotation (Line(points={{491,-356},{510,-356}}, color={0,0,127}));
  connect(booToRea6.y, toV33.x)
    annotation (Line(points={{459,-356},{468,-356}}, color={0,0,127}));
  connect(val.y_actual, reaToBoo2.u) annotation (Line(points={{651,-309},{651,
          -336},{394,-336},{394,-356},{406,-356}}, color={0,0,127}));
  connect(toV34.v, dp_WSE_V)
    annotation (Line(points={{555,-208},{572,-208}}, color={0,0,127}));
  connect(chiWSE.dp_WSE, toV34.x) annotation (Line(points={{673,-200.6},{526,
          -200.6},{526,-208},{532,-208}}, color={0,0,127}));
  connect(toV35.v, dp_Chi_V)
    annotation (Line(points={{545,-246},{562,-246}}, color={0,0,127}));
  connect(chiWSE.dp_Chi, toV35.x) annotation (Line(points={{673,-198.8},{516,
          -198.8},{516,-246},{522,-246}}, color={0,0,127}));
  connect(kToF20.F,toV36. x)
    annotation (Line(points={{683,-278},{692,-278}}, color={0,0,127}));
  connect(toV36.v, T_CHWR_afterWSE_V)
    annotation (Line(points={{715,-278},{734,-278}}, color={0,0,127}));
  connect(chiWSE.TCHWSupWSE, kToF20.K) annotation (Line(points={{673,-212},{646,
          -212},{646,-278},{660,-278}}, color={0,0,127}));
  connect(reaToBoo3.y, booToRea7.u)
    annotation (Line(points={{925,-366},{932,-366}}, color={255,0,255}));
  connect(toV37.v, booCWPump_V)
    annotation (Line(points={{987,-366},{1016,-366}}, color={0,0,127}));
  connect(booToRea7.y, toV37.x)
    annotation (Line(points={{955,-366},{964,-366}}, color={0,0,127}));
  connect(pumCW.y_actual, reaToBoo3.u) annotation (Line(points={{903,-277},{888,
          -277},{888,-366},{902,-366}}, color={0,0,127}));
  connect(toV37.v, booCHWPump_V) annotation (Line(points={{987,-366},{992,-366},
          {992,-386},{1016,-386}}, color={0,0,127}));
  connect(toV38.v, booCT_V)
    annotation (Line(points={{825,-368},{844,-368}}, color={0,0,127}));
  connect(reaToBoo4.y, booToRea8.u)
    annotation (Line(points={{763,-368},{770,-368}}, color={255,0,255}));
  connect(booToRea8.y, toV38.x)
    annotation (Line(points={{793,-368},{802,-368}}, color={0,0,127}));
  connect(cooTow.PFan, reaToBoo4.u) annotation (Line(points={{759,-308},{764,
          -308},{764,-336},{736,-336},{736,-368},{740,-368}}, color={0,0,127}));
  connect(yChiOn, reaToBoo5.u)
    annotation (Line(points={{1062,-290},{1080,-290}}, color={0,0,127}));
  connect(reaToBoo5.y, chiWSE.on[1]) annotation (Line(points={{1103,-290},{1112,
          -290},{1112,-262},{920,-262},{920,-215.6},{695.6,-215.6}}, color={255,
          0,255}));
  connect(yCHWPumSpe, volToUni_yhea6.v)
    annotation (Line(points={{1062,-318},{1080.8,-318}}, color={0,0,127}));
  connect(volToUni_yhea6.y, chiWSE.yPum[1]) annotation (Line(points={{1094.6,
          -318},{1098,-318},{1098,-302},{982,-302},{982,-203.6},{695.6,-203.6}},
        color={0,0,127}));
  connect(yCWPumSpe, volToUni_yhea7.v)
    annotation (Line(points={{1062,-360},{1080.8,-360}}, color={0,0,127}));
  connect(volToUni_yhea7.y, pumCW.y) annotation (Line(points={{1094.6,-360},{
          1094.6,-328},{898,-328},{898,-288}}, color={0,0,127}));
  connect(yCTSpe, volToUni_yhea8.v)
    annotation (Line(points={{1062,-388},{1080.8,-388}}, color={0,0,127}));
  connect(volToUni_yhea8.y, cooTow.y) annotation (Line(points={{1094.6,-388},{
          1098,-388},{1098,-398},{726,-398},{726,-308},{736,-308}}, color={0,0,
          127}));
  connect(kToF21.F, T_CHWSupSet_F)
    annotation (Line(points={{1283,-316},{1302,-316}}, color={0,0,127}));
  connect(temDifPreRes.TSet, kToF21.K) annotation (Line(points={{1217,-249},{
          1217,-258},{1218,-258},{1218,-266},{1242,-266},{1242,-300},{1260,-300},
          {1260,-316}}, color={0,0,127}));
  connect(temDifPreRes.dpSet, dp_CHWSupSet_pa) annotation (Line(points={{1217,
          -239},{1230.5,-239},{1230.5,-224},{1254,-224}}, color={0,0,127}));
  connect(power5.y, toV39.x)
    annotation (Line(points={{403,-310},{410.8,-310}}, color={0,0,127}));
  connect(toV39.v, Power_total_V)
    annotation (Line(points={{424.6,-310},{446,-310}}, color={0,0,127}));
  connect(power4.y, toV40.x)
    annotation (Line(points={{405,-284},{410.8,-284}}, color={0,0,127}));
  connect(toV40.v, Power_ct_V) annotation (Line(points={{424.6,-284},{432,-284},
          {432,-284},{446,-284}}, color={0,0,127}));
  connect(power3.y, toV41.x)
    annotation (Line(points={{405,-262},{410.8,-262}}, color={0,0,127}));
  connect(toV41.v, Power_cwPum_V)
    annotation (Line(points={{424.6,-262},{446,-262}}, color={0,0,127}));
  connect(power2.y, toV42.x)
    annotation (Line(points={{405,-240},{410.8,-240}}, color={0,0,127}));
  connect(toV42.v, Power_chwPum_V)
    annotation (Line(points={{424.6,-240},{446,-240}}, color={0,0,127}));
  connect(power1.y, toV43.x)
    annotation (Line(points={{405,-216},{410.8,-216}}, color={0,0,127}));
  connect(toV43.v, Power_chiller_V) annotation (Line(points={{424.6,-216},{434,
          -216},{434,-216},{446,-216}}, color={0,0,127}));
  connect(toV44.v, Power_fan_V)
    annotation (Line(points={{298.6,-100},{318,-100}}, color={0,0,127}));
  connect(fanSup.P, toV44.x) annotation (Line(points={{321,-31},{321,-72},{272,
          -72},{272,-100},{284.8,-100}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-400},{1440,
            750}})),
    experiment(
      StopTime=604800,
      __Dymola_fixedstepsize=0.01,
      __Dymola_Algorithm="Euler"),
    __Dymola_experimentFlags(Advanced(
        InlineMethod=1,
        InlineOrder=2,
        InlineFixedStep=0.01)),
    Icon(graphics={Text(
          extent={{246,80},{286,22}},
          lineColor={28,108,200},
          textString="VAV Outputs"), Text(
          extent={{-174,120},{-134,62}},
          lineColor={28,108,200},
          textString="VAV Inputs"),
        Rectangle(extent={{-200,-60},{350,-380}}, lineColor={28,108,200})}));
end FiveZonesVAVAHUChiller08042022;
