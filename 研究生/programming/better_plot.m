function better_plot(x,y,LineSpec,LineThickness,xlab,ylab,PlotType,FontSize,gridon) 
    if (PlotType=="plot")
        plot(x,y,LineSpec,'LineWidth',LineThickness);
    end
    if (PlotType=="semilogx")
        semilogx(x,y,LineSpec,'LineWidth',LineThickness);
    end
    if(PlotType=="semilogy")
        loglog(x,y,LineSpec,'LineWidth',LineThickness);
    end
    if(PlotType=="loglog")
        loglog(x,y,LineSpec,'LineWidth',LineThickness);
    end
    xlabel(xlab);
    ylabel(ylab);
    set(gca,'FontSize',FontSize);
    if gridon
        grid on
    end

end
