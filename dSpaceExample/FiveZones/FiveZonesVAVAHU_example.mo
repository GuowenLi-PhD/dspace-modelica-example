within dSpaceExample.FiveZones;
model FiveZonesVAVAHU_example
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Constant yHea(k=0.02)
    annotation (Placement(transformation(extent={{-14,-60},{6,-40}})));
  Modelica.Blocks.Sources.Constant yVAV(k=1)
    annotation (Placement(transformation(extent={{-30,72},{-10,92}})));
  FiveZonesVAVAHU fiveZonesVAVAHU
    annotation (Placement(transformation(extent={{0,-12},{54,20}})));
  Modelica.Blocks.Sources.Constant ySupFanOn(k=1)
    annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
  Modelica.Blocks.Sources.Constant ySupFanSpe(k=1)
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Modelica.Blocks.Sources.Constant yRetDam(k=1)
    annotation (Placement(transformation(extent={{-90,6},{-70,26}})));
  Modelica.Blocks.Sources.Constant yEcoOA(k=1)
    annotation (Placement(transformation(extent={{-90,-26},{-70,-6}})));
  Modelica.Blocks.Sources.Constant yExhDam(k=10)
    annotation (Placement(transformation(extent={{-90,-58},{-70,-38}})));
  Modelica.Blocks.Sources.Constant yCooVal(k=1)
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Modelica.Blocks.Sources.Constant yHeaVal(k=0)
    annotation (Placement(transformation(extent={{-52,-90},{-32,-70}})));
  Modelica.Blocks.Sources.Constant yEcoMinOA(k=10)
    annotation (Placement(transformation(extent={{-128,-18},{-108,2}})));
equation
  connect(yHea.y, fiveZonesVAVAHU.yHeaCor) annotation (Line(points={{7,-50},{8,
          -50},{8,21.6},{9.22909,21.6}}, color={0,0,127}));
  connect(yHea.y, fiveZonesVAVAHU.yHeaWes) annotation (Line(points={{7,-50},{8,
          -50},{8,24.4},{9.22909,24.4}}, color={0,0,127}));
  connect(yHea.y, fiveZonesVAVAHU.yHeaNor) annotation (Line(points={{7,-50},{7,
          -11},{9.22909,-11},{9.22909,27.2}}, color={0,0,127}));
  connect(yHea.y, fiveZonesVAVAHU.yHeaEas) annotation (Line(points={{7,-50},{
          9.22909,-50},{9.22909,30}}, color={0,0,127}));
  connect(yHea.y, fiveZonesVAVAHU.yHeaSou) annotation (Line(points={{7,-50},{
          9.22909,-50},{9.22909,32.8}}, color={0,0,127}));
  connect(yVAV.y, fiveZonesVAVAHU.yVAVSou) annotation (Line(points={{-9,82},{-8,
          82},{-8,32.6},{1.37455,32.6}}, color={0,0,127}));
  connect(yVAV.y, fiveZonesVAVAHU.yVAVEas) annotation (Line(points={{-9,82},{-8,
          82},{-8,29.8},{1.37455,29.8}}, color={0,0,127}));
  connect(yVAV.y, fiveZonesVAVAHU.yVAVNor) annotation (Line(points={{-9,82},{-8,
          82},{-8,27},{1.37455,27}}, color={0,0,127}));
  connect(yVAV.y, fiveZonesVAVAHU.yVAVWes) annotation (Line(points={{-9,82},{-8,
          82},{-8,24.2},{1.37455,24.2}}, color={0,0,127}));
  connect(yVAV.y, fiveZonesVAVAHU.yVAVCor) annotation (Line(points={{-9,82},{-8,
          82},{-8,21.4},{1.37455,21.4}}, color={0,0,127}));
  connect(yHeaVal.y, fiveZonesVAVAHU.yHeaVal) annotation (Line(points={{-31,-80},
          {-16,-80},{-16,11},{-0.981818,11}}, color={0,0,127}));
  connect(yCooVal.y, fiveZonesVAVAHU.yCooVal) annotation (Line(points={{-69,-80},
          {-34,-80},{-34,11},{-0.981818,11}}, color={0,0,127}));
  connect(yExhDam.y, fiveZonesVAVAHU.yExhDam) annotation (Line(points={{-69,-48},
          {-36,-48},{-36,11},{-0.981818,11}}, color={0,0,127}));
  connect(yEcoOA.y, fiveZonesVAVAHU.yEcoOADam) annotation (Line(points={{-69,
          -16},{-36,-16},{-36,13},{-0.981818,13}}, color={0,0,127}));
  connect(yRetDam.y, fiveZonesVAVAHU.yRetAirDam) annotation (Line(points={{-69,
          16},{-36,16},{-36,15},{-0.981818,15}}, color={0,0,127}));
  connect(ySupFanSpe.y, fiveZonesVAVAHU.ySupFanSpe) annotation (Line(points={{
          -69,50},{-36,50},{-36,11},{-0.981818,11}}, color={0,0,127}));
  connect(ySupFanOn.y, fiveZonesVAVAHU.ySupFanOn) annotation (Line(points={{-69,
          82},{-36,82},{-36,17},{-0.981818,17}}, color={0,0,127}));
  connect(yEcoMinOA.y, fiveZonesVAVAHU.yMinOADam) annotation (Line(points={{
          -107,-8},{-54,-8},{-54,13},{-0.981818,13}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=36000,
      __Dymola_fixedstepsize=0.01,
      __Dymola_Algorithm="Euler"),
    __Dymola_experimentFlags(Advanced(
        InlineMethod=1,
        InlineOrder=2,
        InlineFixedStep=0.01)));
end FiveZonesVAVAHU_example;
