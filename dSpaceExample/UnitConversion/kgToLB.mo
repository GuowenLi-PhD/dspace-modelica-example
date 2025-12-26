within dSpaceExample.UnitConversion;
model kgToLB
  Modelica.Blocks.Interfaces.RealInput kg "weight in kg"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput lb "weight in lb" annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(extent=
            {{100,-10},{120,10}})));

equation
  lb = 0.000145038*kg annotation (Icon(coordinateSystem(preserveAspectRatio=
            false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-159,152},{141,112}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=
            false)));
end kgToLB;
