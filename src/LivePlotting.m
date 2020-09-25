% LivePlotting    DEFORM: Plot model results live during run
%
% []  =  LivePlotting(CTX)
%
%   Function creates figures and plots model solution and material point 
%   properties live during model run. 
%
%   modified  20170427  Tobias Keller
%   modified  20200227  Tobias Keller
%   modified  20200922  Tobias Keller


function  []  =  LivePlotting(CTX)

if strcmp(CTX.IO.LivePlot,'ON')
    
    if CTX.FE.nxEl >= CTX.FE.nzEl
        sp1 = 211;
        sp2 = 212;
    else
        sp1 = 121;
        sp2 = 122;
    end
    
    n=1;
    
    if std(CTX.MP.Mat)>=1e-6
        figure(n); n=n+1; clf;
        subplot(sp1);
        PlotField(CTX.MP.Mat,CTX.FE,CTX.IO.PlotStyle);
        title('Material types')
        subplot(sp2);
        PlotField(CTX.MP.Rho,CTX.FE,CTX.IO.PlotStyle);
        title('Density [kg/m3]')
        drawnow
    end
    
    figure(n); n=n+1; clf;
    subplot(sp1);
    PlotField( CTX.SL.U*CTX.TIME.spyr*1000,CTX.FE,[CTX.IO.PlotStyle,'U']);
    title('x-Velocity [mm/yr]')
    subplot(sp2);
    PlotField(-CTX.SL.W*CTX.TIME.spyr*1000,CTX.FE,CTX.IO.PlotStyle);
    title('z-Velocity [mm/yr]')
    drawnow
    
    figure(n); n=n+1; clf;
    subplot(211);
    PlotField(log10(CTX.MP.EII(:,1)),CTX.FE,CTX.IO.PlotStyle);
    title('Shear strain rate [log10 1/s]')
    subplot(212);
    PlotField(log10(CTX.MP.TII),CTX.FE,CTX.IO.PlotStyle);
    title('Shear stress [log10 Pa]')
    drawnow
    
    figure(n); n=n+1; clf;
    subplot(sp1);
    if strcmp(CTX.FE.ElType(3:4),'P0')
        P  =  PElQ1(CTX.SL.P,CTX.FE);
    end
    PlotField(P./1e6,CTX.FE,CTX.IO.PlotStyle);
    title('Dynamic pressure [MPa]')
    subplot(sp2);
    if strcmp(CTX.FE.ElType(3:4),'P0')
        Pt  =  PElQ1(CTX.SL.Pt,CTX.FE);
    end
    PlotField(Pt./1e6,CTX.FE,CTX.IO.PlotStyle);
    title('Total pressure [MPa]')
    drawnow
    
    figure(n); n=n+1; clf;
    subplot(2,2,1);
    PlotField(log10(CTX.MP.Eta),CTX.FE,CTX.IO.PlotStyle);
    title('Viscosity [log10 Pas]')
    subplot(2,2,2);
    PlotField(log10(CTX.MP.EtaVP),CTX.FE,CTX.IO.PlotStyle);
    title('Visco-plasticity [log10 Pas]')
    subplot(2,2,3);
    PlotField((CTX.MP.Chi),CTX.FE,CTX.IO.PlotStyle);
    title('Visco-elasticity [1]')
    subplot(2,2,4);
    PlotField(log10(CTX.MP.EtaVEP),CTX.FE,CTX.IO.PlotStyle);
    title('Visco-elasto-plasticity [log10 Pas]')
    drawnow
    
    figure(n); n=n+1; clf;
    subplot(sp1);
    PlotField(log10(CTX.MP.YieldStr),CTX.FE,CTX.IO.PlotStyle);
    title('Yield Stress [log10 Pa]')
    subplot(sp2);
    PlotField(CTX.MP.Dmg,CTX.FE,CTX.IO.PlotStyle);
    title('Damage strain [1]')
    drawnow
    
    figure(n); n=n+1; clf;
    subplot(2,2,1);
    PlotField(max(-18,log10(CTX.MP.EII(:,1))),CTX.FE,CTX.IO.PlotStyle);
    title('Strain-rate total [log10 1/s]')
    subplot(2,2,2);
    PlotField(max(-18,log10(CTX.MP.EII(:,2))),CTX.FE,CTX.IO.PlotStyle);
    title('Strain-rate viscous [log10 1/s]')
    subplot(2,2,3);
    PlotField(max(-18,log10(CTX.MP.EII(:,3))),CTX.FE,CTX.IO.PlotStyle);
    title('Strain-rate elastic [log10 1/s]')
    subplot(2,2,4);
    PlotField(max(-18,log10(CTX.MP.EII(:,4))),CTX.FE,CTX.IO.PlotStyle);
    title('Strain-rate plastic [log10 1/s]')
    drawnow
    
end

end