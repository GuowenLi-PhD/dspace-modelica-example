within dSpaceExample.FiveZones;
model FiveZonesVAVAHU_v2 "System example for fault injection"
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
  extends dSpaceExample.FiveZones.BaseClasses.PartialAirsideFiveZonesAHU_v1(
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
      nor(T_start=273.15 + 24)));
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
    annotation (Placement(transformation(extent={{1044,-120},{1064,-100}})));
  FaultInjection.Experimental.SystemLevelFaults.Controls.ChillerPlantEnableDisable
    chiPlaEnaDis(yFanSpeMin=0.15,
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
    v_min=0,
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
    v_min=0,
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
    v_min=0,
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
    v_min=0,
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
    v_min=0,
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
          extent={{596,244},{616,264}}), iconTransformation(extent={{200,-60},{220,
            -40}})));
  Modelica.Blocks.Interfaces.RealOutput VCor_flow
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{596,386},{616,406}}), iconTransformation(extent=
           {{320,-58},{340,-38}})));
  Modelica.Blocks.Interfaces.RealOutput TDisSou
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{778,240},{798,260}}), iconTransformation(extent={{200,20},{220,
            40}})));
  Modelica.Blocks.Interfaces.RealOutput VSou_flow
    "Volume flow rate from port_a to port_b" annotation (Placement(
        transformation(extent={{760,392},{780,412}}), iconTransformation(extent=
           {{320,22},{340,42}})));
  Modelica.Blocks.Interfaces.RealOutput TDisEas
    "Temperature of the passing fluid" annotation (Placement(transformation(
          extent={{954,244},{974,264}}), iconTransformation(extent={{200,0},{220,
            20}})));
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
  UnitConversion.FromAnalog volToUni_3(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{-100,24},{-82,42}})));
  UnitConversion.FromAnalog volToUni_5(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{-100,56},{-82,74}})));
  Modelica.Blocks.Interfaces.RealInput yExhDam
    "Voltage signal for exhaust damper position" annotation (Placement(
        transformation(extent={{-130,24},{-112,42}}),
                                                    iconTransformation(extent={{
            -220,-160},{-200,-140}})));
  Modelica.Blocks.Interfaces.RealInput yEcoOADam
    "Voltage signal for economizer OA damper position" annotation (Placement(
        transformation(extent={{-130,56},{-112,74}}),iconTransformation(extent={
            {-220,-140},{-200,-120}})));
  UnitConversion.FromAnalog volToUni_4(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1) annotation (Placement(transformation(extent={{-100,84},{-82,102}})));
  Modelica.Blocks.Interfaces.RealInput yRetAirDam
    "Voltage signal for return damper position" annotation (Placement(
        transformation(extent={{-130,84},{-112,102}}),iconTransformation(extent=
           {{-220,-120},{-200,-100}})));
  UnitConversion.FromAnalog volToUni_6(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{252,-114},{270,-96}})));
  Modelica.Blocks.Interfaces.RealInput ySupFanSpe
    "Voltage signal for ahu supply fan speed" annotation (Placement(
        transformation(extent={{218,-114},{236,-96}}),iconTransformation(extent=
           {{-220,-160},{-200,-140}})));
  UnitConversion.FromAnalog volToUni_7(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{-36,-174},{-18,-156}})));
  Modelica.Blocks.Interfaces.RealInput yHeaVal
    "Voltage signal for ahu heating valve" annotation (Placement(transformation(
          extent={{-70,-174},{-52,-156}}),
                                         iconTransformation(extent={{-220,-160},
            {-200,-140}})));
  UnitConversion.FromAnalog volToUni_1(
    v_min=0,
    v_max=10,
    y_min=0,
    y_max=1)
    annotation (Placement(transformation(extent={{422,434},{440,452}})));
  Modelica.Blocks.Interfaces.RealInput yCooVal
    "Voltage signal for ahu cooling valve" annotation (Placement(transformation(
          extent={{388,434},{406,452}}), iconTransformation(extent={{-220,-160},
            {-200,-140}})));
  Modelica.Blocks.Math.RealToBoolean reaToBoo(threshold=0.8)
    annotation (Placement(transformation(extent={{360,700},{380,720}})));
  Modelica.Blocks.Interfaces.RealInput ySupFanOn
    "Voltage signal for ahu supply fan on/off" annotation (Placement(
        transformation(extent={{330,700},{350,720}}), iconTransformation(extent=
           {{-220,-100},{-200,-80}})));
  UnitConversion.ToAnolog toV20(
    x_min=0,
    x_max=1,
    v_min=0,
    v_max=5)
    annotation (Placement(transformation(extent={{494,708},{514,728}})));
  Modelica.Blocks.Math.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{460,708},{480,728}})));
  Modelica.Blocks.Interfaces.RealOutput BSupFanOn_V "supply fan status"
    annotation (Placement(transformation(extent={{552,708},{572,728}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput BRetFanOn_V "return fan status"
    annotation (Placement(transformation(extent={{552,686},{572,706}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput BSupFanOn "supply fan status"
    annotation (Placement(transformation(extent={{486,686},{506,706}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  UnitConversion.KToF kToF11
    annotation (Placement(transformation(extent={{334,68},{354,88}})));
  UnitConversion.ToAnolog toV16(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{362,68},{382,88}})));
  Modelica.Blocks.Interfaces.RealOutput TSup_V "AHU supply air temperature"
                                                                  annotation (
      Placement(transformation(extent={{390,68},{410,88}}),
        iconTransformation(extent={{350,-100},{370,-80}})));
  Modelica.Blocks.Interfaces.RealOutput TSup_ahu "AHU supply air temperature"
    annotation (Placement(transformation(extent={{360,92},{380,112}}),
        iconTransformation(extent={{350,-100},{370,-80}})));
  Modelica.Blocks.Interfaces.RealOutput CCLT_V
    "cooling coil leaving temperature" annotation (Placement(transformation(
          extent={{392,36},{412,56}}), iconTransformation(extent={{350,-140},{370,
            -120}})));
  UnitConversion.ToAnolog toV18(
    x_min=0,
    x_max=22000,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{-116,126},{-98,146}})));
  UnitConversion.VToCFM vToCFM_ahu
    annotation (Placement(transformation(extent={{-146,128},{-130,144}})));
  Modelica.Blocks.Interfaces.RealOutput VOut_flow "Outdoor air flowrate"
    annotation (Placement(transformation(extent={{-124,142},{-104,162}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  Modelica.Blocks.Interfaces.RealOutput VOut_flow_V "Outdoor air flowrate"
    annotation (Placement(transformation(extent={{-88,126},{-68,146}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.KToF kToF12
    annotation (Placement(transformation(extent={{52,48},{72,68}})));
  UnitConversion.ToAnolog toV17(
    x_min=-20,
    x_max=120,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{80,48},{100,68}})));
  Modelica.Blocks.Interfaces.RealOutput TMix_V
    "Mixed air temperautre leaviing economizer" annotation (Placement(
        transformation(extent={{114,48},{134,68}}), iconTransformation(extent={
            {350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput HCET_V
    "heating coil entering temperature" annotation (Placement(transformation(
          extent={{114,30},{134,50}}), iconTransformation(extent={{350,-140},{370,
            -120}})));
  Modelica.Blocks.Interfaces.RealOutput TMix_ahu
    "Mixed air temperautre leaviing economizer" annotation (Placement(
        transformation(extent={{84,70},{104,90}}),  iconTransformation(extent={{
            350,-140},{370,-120}})));
  UnitConversion.ToAnolog toV19(
    x_min=0,
    x_max=0.2,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{252,144},{272,164}})));
  UnitConversion.PaToPSI paTopsi_ahu
    annotation (Placement(transformation(extent={{222,144},{242,164}})));
  Modelica.Blocks.Interfaces.RealOutput dpDisSupFan_V
    "Supply fan static discharge pressure" annotation (Placement(transformation(
          extent={{280,144},{300,164}}),iconTransformation(extent={{350,-160},{
            370,-140}})));
  Modelica.Blocks.Interfaces.RealOutput dpDisSupFan_ahu
    "Supply fan static discharge pressure" annotation (Placement(transformation(
          extent={{280,122},{300,142}}), iconTransformation(extent={{350,-160},{
            370,-140}})));
  UnitConversion.KToF kToF13
    annotation (Placement(transformation(extent={{30,190},{50,210}})));
  UnitConversion.ToAnolog toV22(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{58,190},{78,210}})));
  Modelica.Blocks.Interfaces.RealOutput TRet_ahu_V "ahu return air temperautre"
    annotation (Placement(transformation(extent={{82,190},{102,210}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput TRet_ahu "ahu return air temperautre"
    annotation (Placement(transformation(extent={{54,218},{74,238}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  UnitConversion.ToAnolog toV21(
    x_min=0,
    x_max=22000,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{362,230},{382,250}})));
  UnitConversion.VToCFM vToCFM_ahu1
    annotation (Placement(transformation(extent={{332,230},{352,250}})));
  Modelica.Blocks.Interfaces.RealOutput VRet_flow "Return air flowrate"
    annotation (Placement(transformation(extent={{358,266},{378,286}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  Modelica.Blocks.Interfaces.RealOutput VRet_flow_V "Return air flowrate"
    annotation (Placement(transformation(extent={{394,230},{414,250}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.ToAnolog toV23(
    x_min=0,
    x_max=22000,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{256,74},{276,94}})));
  Modelica.Blocks.Interfaces.RealOutput VSup_ahu_V "Supply air flowrate"
    annotation (Placement(transformation(extent={{282,74},{302,94}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
  UnitConversion.VToCFM vToCFM_ahu2
    annotation (Placement(transformation(extent={{226,74},{246,94}})));
  UnitConversion.KToF kToF17
    annotation (Placement(transformation(extent={{64,-22},{84,-2}})));
  UnitConversion.ToAnolog toV27(
    x_min=25,
    x_max=125,
    v_min=0,
    v_max=10)
    annotation (Placement(transformation(extent={{92,-22},{112,-2}})));
  Modelica.Blocks.Interfaces.RealOutput HCLT_V
    "heating coil leaving temperature" annotation (Placement(transformation(
          extent={{120,-22},{140,-2}}),
                                      iconTransformation(extent={{350,-140},{370,
            -120}})));
  Modelica.Blocks.Interfaces.RealOutput CCET_V
    "cooling coil entering temperature" annotation (Placement(transformation(
          extent={{120,-2},{140,18}}), iconTransformation(extent={{350,-140},{370,
            -120}})));
  Modelica.Blocks.Interfaces.RealOutput HCLT "heating coil leaving temperature"
    annotation (Placement(transformation(extent={{88,-4},{108,16}}),
        iconTransformation(extent={{350,-140},{370,-120}})));
  Modelica.Blocks.Interfaces.RealOutput VSup_ahu "Supply air flowrate"
    annotation (Placement(transformation(extent={{248,106},{268,126}}),
        iconTransformation(extent={{350,-120},{370,-100}})));
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
  connect(proCHWP.y, chiWSE.yPum[1]) annotation (Line(points={{1398,-250},{1404,
          -250},{1404,-340},{704,-340},{704,-203.6},{695.6,-203.6}},
                                        color={0,0,127}));
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
  connect(cooModCon.yPla, chiPlaEnaDis.yPla) annotation (Line(points={{1026,
          -247.333},{1022,-247.333},{1022,-70},{1142,-70},{1142,-110},{1121,
          -110}}, color={255,0,255}));
  connect(gai.y, pumCW.y) annotation (Line(points={{1347,-206},{1400,-206},{1400,
          -342},{880,-342},{880,-288},{898,-288}}, color={0,0,127}));
  connect(cooTowSpeCon.y, cooTow.y) annotation (Line(points={{1307,-97.1111},{
          1402,-97.1111},{1402,-344},{722,-344},{722,-308},{736,-308}},
                                                                      color={0,
          0,127}));
  connect(chiOn.y, chiWSE.on[1]) annotation (Line(points={{1347,-128},{1408,-128},
          {1408,-338},{868,-338},{868,-215.6},{695.6,-215.6}},
                                                            color={255,0,255}));
  connect(chiPlaEnaDis.yPla, booToRea.u)
    annotation (Line(points={{1121,-110},{1142,-110},{1142,-116},{1166,-116}},
                                                       color={255,0,255}));
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
          -110},{1072,-110},{1072,-114},{1098,-114}},      color={255,127,0}));
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
  connect(chiPlaEnaDis.yPla, minFloBypCHW.yPla) annotation (Line(points={{1121,
          -110},{1142,-110},{1142,-128},{1024,-128},{1024,-153},{1038,-153}},
        color={255,0,255}));
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
  connect(kToF6.F, TDisCor) annotation (Line(points={{521,280},{560,280},{560,254},
          {606,254}}, color={0,0,127}));
  connect(vToCFM_vav1.CFM, VCor_flow) annotation (Line(points={{521,342},{560,342},
          {560,396},{606,396}}, color={0,0,127}));
  connect(kToF7.F, TDisSou) annotation (Line(points={{691,280},{734.5,280},{734.5,
          250},{788,250}}, color={0,0,127}));
  connect(vToCFM_vav2.CFM, VSou_flow) annotation (Line(points={{693,340},{728.5,
          340},{728.5,402},{770,402}}, color={0,0,127}));
  connect(kToF8.F, TDisEas) annotation (Line(points={{907,280},{932,280},{932,254},
          {964,254}}, color={0,0,127}));
  connect(vToCFM_vav3.CFM, VEas_flow) annotation (Line(points={{905,340},{934,340},
          {934,324},{972,324}}, color={0,0,127}));
  connect(kToF9.F, TDisNor) annotation (Line(points={{1073,280},{1096,280},{1096,
          246},{1124,246}}, color={0,0,127}));
  connect(vToCFM_vav4.CFM, VNor_flow) annotation (Line(points={{1063,340},{1092.5,
          340},{1092.5,372},{1132,372}}, color={0,0,127}));
  connect(kToF10.F, TDisWes) annotation (Line(points={{1233,280},{1261.5,280},{1261.5,
          234},{1298,234}}, color={0,0,127}));
  connect(vToCFM_vav5.CFM, VWes_flow) annotation (Line(points={{1227,342},{1227,
          380},{1298,380},{1298,420}}, color={0,0,127}));
  connect(kToF1.F, TRooAirSou) annotation (Line(points={{1121,710},{1046,710},{1046,
          714},{978,714}}, color={0,0,127}));
  connect(kToF2.F, TRooAirEas) annotation (Line(points={{1121,682},{1046.5,682},
          {1046.5,688},{978,688}}, color={0,0,127}));
  connect(kToF3.F, TRooAirNor) annotation (Line(points={{1121,630},{1047.5,630},
          {1047.5,650},{980,650}}, color={0,0,127}));
  connect(kToF4.F, TRooAirWes) annotation (Line(points={{1121,600},{1050,600},{1050,
          606},{982,606}}, color={0,0,127}));
  connect(kToF5.F, TRooAirCor) annotation (Line(points={{1121,560},{1050.5,560},
          {1050.5,580},{984,580}}, color={0,0,127}));
  connect(kToF_TOut.F,TOutAir)  annotation (Line(points={{-335,280},{-332,280},{
          -332,340},{-320,340}}, color={0,0,127}));
  connect(gain.y,RHOut)  annotation (Line(points={{-335,246},{-330,246},{-330,320},
          {-320,320}}, color={0,0,127}));
  connect(reaTDryBul.y, kToF_TOut.K) annotation (Line(points={{-369,156},{-369,280},
          {-358,280}}, color={0,0,127}));
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
  connect(yExhDam,volToUni_3. v)
    annotation (Line(points={{-121,33},{-101.8,33}},
                                                  color={0,0,127}));
  connect(yEcoOADam,volToUni_5. v)
    annotation (Line(points={{-121,65},{-101.8,65}},
                                                   color={0,0,127}));
  connect(yRetAirDam,volToUni_4. v)
    annotation (Line(points={{-121,93},{-101.8,93}}, color={0,0,127}));
  connect(volToUni_4.y, eco.yRet) annotation (Line(points={{-81.1,93},{-16.8,93},
          {-16.8,-34}}, color={0,0,127}));
  connect(volToUni_5.y, eco.yOut)
    annotation (Line(points={{-81.1,65},{-10,65},{-10,-34}}, color={0,0,127}));
  connect(volToUni_3.y, eco.yExh)
    annotation (Line(points={{-81.1,33},{-3,33},{-3,-34}}, color={0,0,127}));
  connect(ySupFanSpe,volToUni_6. v)
    annotation (Line(points={{227,-105},{250.2,-105}},
                                                     color={0,0,127}));
  connect(volToUni_6.y, fanSup.y) annotation (Line(points={{270.9,-105},{270.9,
          -12},{310,-12},{310,-28}}, color={0,0,127}));
  connect(yHeaVal,volToUni_7. v)
    annotation (Line(points={{-61,-165},{-37.8,-165}},
                                                     color={0,0,127}));
  connect(volToUni_7.y, swiFreSta.u3) annotation (Line(points={{-17.1,-165},{12,
          -165},{12,-138},{18,-138}}, color={0,0,127}));
  connect(yCooVal,volToUni_1. v)
    annotation (Line(points={{397,443},{420.2,443}}, color={0,0,127}));
  connect(volToUni_1.y, proCHWVal.u1) annotation (Line(points={{440.9,443},{
          440.9,-102},{466,-102}}, color={0,0,127}));
  connect(volToUni_1.y, plaReqChi.uPlaVal) annotation (Line(points={{440.9,443},
          {440.9,-94},{1042,-94},{1042,-110}}, color={0,0,127}));
  connect(ySupFanOn,reaToBoo. u)
    annotation (Line(points={{340,710},{358,710}}, color={0,0,127}));
  connect(booToRea1.y,toV20. x)
    annotation (Line(points={{481,718},{492,718}}, color={0,0,127}));
  connect(toV20.v,BSupFanOn_V)  annotation (Line(points={{515,718},{562,718}},
                           color={0,0,127}));
  connect(toV20.v, BRetFanOn_V) annotation (Line(points={{515,718},{534,718},{
          534,696},{562,696}}, color={0,0,127}));
  connect(booToRea1.y, BSupFanOn) annotation (Line(points={{481,718},{484,718},
          {484,696},{496,696}}, color={0,0,127}));
  connect(reaToBoo.y, boiPlaEnaDis.ySupFan) annotation (Line(points={{381,710},
          {382,710},{382,686},{-290,686},{-290,-160},{-280,-160}}, color={255,0,
          255}));
  connect(reaToBoo.y, andFreSta.u2) annotation (Line(points={{381,710},{382,710},
          {382,690},{-80,690},{-80,-138},{-22,-138}}, color={255,0,255}));
  connect(reaToBoo.y, sigChaFan.u) annotation (Line(points={{381,710},{1434,710},
          {1434,560},{1458,560}}, color={255,0,255}));
  connect(reaToBoo.y, booToReaSupFan.u) annotation (Line(points={{381,710},{442,
          710},{442,652},{1218,652}}, color={255,0,255}));
  connect(reaToBoo.y, booToRea1.u) annotation (Line(points={{381,710},{458,710},
          {458,718}}, color={255,0,255}));
  connect(reaToBoo.y, chiPlaEnaDis.ySupFan) annotation (Line(points={{381,710},
          {436,710},{436,636},{1092,636},{1092,-110},{1098,-110}}, color={255,0,
          255}));
  connect(kToF11.F,toV16. x)
    annotation (Line(points={{355,78},{360,78}}, color={0,0,127}));
  connect(toV16.v,TSup_V)
    annotation (Line(points={{383,78},{400,78}}, color={0,0,127}));
  connect(kToF11.F,TSup_ahu)  annotation (Line(points={{355,78},{356,78},{356,
          102},{370,102}},
                      color={0,0,127}));
  connect(toV16.v, CCLT_V)
    annotation (Line(points={{383,78},{383,46},{402,46}}, color={0,0,127}));
  connect(TSup.T, kToF11.K) annotation (Line(points={{340,-29},{342,-29},{342,
          54},{332,54},{332,78}}, color={0,0,127}));
  connect(vToCFM_ahu.CFM,toV18. x)
    annotation (Line(points={{-129.2,136},{-117.8,136}},
                                                   color={0,0,127}));
  connect(vToCFM_ahu.CFM,VOut_flow)  annotation (Line(points={{-129.2,136},{
          -129.2,152},{-114,152}},        color={0,0,127}));
  connect(toV18.v, VOut_flow_V)
    annotation (Line(points={{-97.1,136},{-78,136}}, color={0,0,127}));
  connect(VOut1.V_flow, vToCFM_ahu.V_flow) annotation (Line(points={{-61,-20.9},
          {-147.6,-20.9},{-147.6,136}}, color={0,0,127}));
  connect(kToF12.F,toV17. x)
    annotation (Line(points={{73,58},{78,58}}, color={0,0,127}));
  connect(toV17.v,TMix_V)
    annotation (Line(points={{101,58},{124,58}}, color={0,0,127}));
  connect(kToF12.F, TMix_ahu)
    annotation (Line(points={{73,58},{73,80},{94,80}}, color={0,0,127}));
  connect(toV17.v, HCET_V) annotation (Line(points={{101,58},{108,58},{108,40},
          {124,40}}, color={0,0,127}));
  connect(TMix.T, kToF12.K)
    annotation (Line(points={{40,-29},{40,58},{50,58}}, color={0,0,127}));
  connect(toV19.v,dpDisSupFan_V)
    annotation (Line(points={{273,154},{290,154}},
                                                 color={0,0,127}));
  connect(paTopsi_ahu.PSI,toV19. x)
    annotation (Line(points={{243,154},{250,154}},
                                                 color={0,0,127}));
  connect(paTopsi_ahu.PSI, dpDisSupFan_ahu) annotation (Line(points={{243,154},
          {246,154},{246,132},{290,132}}, color={0,0,127}));
  connect(dpDisSupFan.p_rel, paTopsi_ahu.Pa) annotation (Line(points={{311,0},{
          212,0},{212,154},{220,154}}, color={0,0,127}));
  connect(kToF13.F,toV22. x)
    annotation (Line(points={{51,200},{56,200}},
                                               color={0,0,127}));
  connect(toV22.v,TRet_ahu_V)
    annotation (Line(points={{79,200},{92,200}}, color={0,0,127}));
  connect(kToF13.F,TRet_ahu)  annotation (Line(points={{51,200},{54,200},{54,
          228},{64,228}},
                     color={0,0,127}));
  connect(TRet.T, kToF13.K) annotation (Line(points={{100,151},{30,151},{30,200},
          {28,200}}, color={0,0,127}));
  connect(vToCFM_ahu1.CFM,toV21. x)
    annotation (Line(points={{353,240},{360,240}}, color={0,0,127}));
  connect(vToCFM_ahu1.CFM,VRet_flow)  annotation (Line(points={{353,240},{353,
          276},{368,276}},      color={0,0,127}));
  connect(toV21.v,VRet_flow_V)  annotation (Line(points={{383,240},{404,240}},
                                 color={0,0,127}));
  connect(senRetFlo.V_flow, vToCFM_ahu1.V_flow) annotation (Line(points={{350,
          151},{350,198},{330,198},{330,240}}, color={0,0,127}));
  connect(toV23.v,VSup_ahu_V)
    annotation (Line(points={{277,84},{292,84}}, color={0,0,127}));
  connect(vToCFM_ahu2.CFM, toV23.x)
    annotation (Line(points={{247,84},{254,84}}, color={0,0,127}));
  connect(senSupFlo.V_flow, vToCFM_ahu2.V_flow) annotation (Line(points={{410,
          -29},{410,36},{224,36},{224,84}}, color={0,0,127}));
  connect(kToF17.F, toV27.x)
    annotation (Line(points={{85,-12},{90,-12}}, color={0,0,127}));
  connect(toV27.v, HCLT_V)
    annotation (Line(points={{113,-12},{130,-12}}, color={0,0,127}));
  connect(toV27.v, CCET_V) annotation (Line(points={{113,-12},{118,-12},{118,8},
          {130,8}}, color={0,0,127}));
  connect(kToF17.F, HCLT)
    annotation (Line(points={{85,-12},{85,6},{98,6}}, color={0,0,127}));
  connect(THeaCoo.T, kToF17.K) annotation (Line(points={{154,-29},{106,-29},{
          106,-28},{62,-28},{62,-12}}, color={0,0,127}));
  connect(vToCFM_ahu2.CFM, VSup_ahu) annotation (Line(points={{247,84},{248,84},
          {248,116},{258,116}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-400},{1440,
            750}})),
    experiment(
      StopTime=86400,
      __Dymola_fixedstepsize=0.1,
      __Dymola_Algorithm="Euler"),
    __Dymola_experimentFlags(Advanced(
        InlineMethod=1,
        InlineOrder=2,
        InlineFixedStep=0.1)),
    Icon(graphics={Text(
          extent={{246,80},{286,22}},
          lineColor={28,108,200},
          textString="VAV Outputs"), Text(
          extent={{-174,120},{-134,62}},
          lineColor={28,108,200},
          textString="VAV Inputs")}));
end FiveZonesVAVAHU_v2;
