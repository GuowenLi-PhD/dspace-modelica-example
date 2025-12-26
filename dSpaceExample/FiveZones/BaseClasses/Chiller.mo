within dSpaceExample.FiveZones.BaseClasses;
record Chiller =
  Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
    QEva_flow_nominal =  -1076100,
    COP_nominal =         5.52,
    PLRMin =              0.10,
    PLRMinUnl =           0.10,
    PLRMax =              1.02,
    mEva_flow_nominal =   1000 * 0.03186,
    mCon_flow_nominal =   1000 * 0.04744,
    TEvaLvg_nominal =     273.15 + 5.56,
    TConEnt_nominal =     273.15 + 24.89,
    TEvaLvgMin =          273.15 + 5.56,
    TEvaLvgMax =          273.15 + 10.00,
    TConEntMin =          273.15 + 12.78,
    TConEntMax =          273.15 + 24.89,
    capFunT =             {1.042261E+00,2.644821E-03,-1.468026E-03,1.366256E-02,-8.302334E-04,1.573579E-03},
    EIRFunT =             {1.026340E+00,-1.612819E-02,-1.092591E-03,-1.784393E-02,7.961842E-04,-9.586049E-05},
    EIRFunPLR =           {1.188880E-01,6.723542E-01,2.068754E-01},
    etaMotor =            1.0)
  "ElectricEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes" annotation (
  defaultComponentName="datChi",
  defaultComponentPrefixes="parameter",
  Documentation(info=
                 "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:

</html>"));
