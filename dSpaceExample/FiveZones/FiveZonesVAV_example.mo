within dSpaceExample.FiveZones;
model FiveZonesVAV_example
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Constant zer(k=0)
    annotation (Placement(transformation(extent={{-14,-60},{6,-40}})));
  Modelica.Blocks.Sources.CombiTimeTable sch(
    table=[0,0; 7*3600,0; 7*3600,10; 19*3600,10; 19*3600,0; 24*3600,0],
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.CombiTimeTable sch1(
    table=[0,0; 7*3600,0; 7*3600,10; 19*3600,10; 19*3600,0; 24*3600,0],
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-100,56},{-80,76}})));
  Modelica.Blocks.Sources.CombiTimeTable sch2(
    table=[0,0; 7*3600,0; 7*3600,10; 19*3600,10; 19*3600,0; 24*3600,0],
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.CombiTimeTable sch3(
    table=[0,0; 7*3600,0; 7*3600,10; 19*3600,10; 19*3600,0; 24*3600,0],
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.CombiTimeTable sch4(
    table=[0,0; 7*3600,0; 7*3600,10; 19*3600,10; 19*3600,0; 24*3600,0],
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-40,56},{-20,76}})));
  FiveZonesVAV fiveZonesVAV
    annotation (Placement(transformation(extent={{2,-22},{58,10}})));
  Modelica.Blocks.Sources.Constant zer1(k=1)
    annotation (Placement(transformation(extent={{-58,-4},{-38,16}})));
equation
  connect(zer.y, fiveZonesVAV.yHeaWes) annotation (Line(points={{7,-50},{10,-50},
          {10,14.4},{11.5709,14.4}}, color={0,0,127}));
  connect(zer.y, fiveZonesVAV.yHeaCor) annotation (Line(points={{7,-50},{10,-50},
          {10,11.6},{11.5709,11.6}}, color={0,0,127}));
  connect(zer.y, fiveZonesVAV.yHeaNor) annotation (Line(points={{7,-50},{8,-50},
          {8,17.2},{11.5709,17.2}}, color={0,0,127}));
  connect(zer.y, fiveZonesVAV.yHeaEas) annotation (Line(points={{7,-50},{10,-50},
          {10,20},{11.5709,20}}, color={0,0,127}));
  connect(zer.y, fiveZonesVAV.yHeaSou) annotation (Line(points={{7,-50},{10,-50},
          {10,22.8},{11.5709,22.8}}, color={0,0,127}));
  connect(zer1.y, fiveZonesVAV.yVAVWes) annotation (Line(points={{-37,6},{-16,6},
          {-16,14.2},{3.42545,14.2}}, color={0,0,127}));
  connect(zer1.y, fiveZonesVAV.yVAVCor) annotation (Line(points={{-37,6},{-16,6},
          {-16,11.4},{3.42545,11.4}}, color={0,0,127}));
  connect(zer1.y, fiveZonesVAV.yVAVNor) annotation (Line(points={{-37,6},{-16,6},
          {-16,17},{3.42545,17}}, color={0,0,127}));
  connect(zer1.y, fiveZonesVAV.yVAVEas) annotation (Line(points={{-37,6},{-16,6},
          {-16,19.8},{3.42545,19.8}}, color={0,0,127}));
  connect(zer1.y, fiveZonesVAV.yVAVSou) annotation (Line(points={{-37,6},{-16,6},
          {-16,22.6},{3.42545,22.6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FiveZonesVAV_example;
