clc
clear all
close all

openfig('fig1.fig');
ax1=gca;
openfig('fig2.fig')
ax2=gca;
openfig('fig3.fig');
ax3=gca;
openfig('fig4.fig')
ax4=gca;
 
 
figure;
axis xy;
colormap(colormapVoicebox);
tcl=tiledlayout(2,2);
ax1.Parent=tcl;
ax1.Layout.Tile=1;
ax2.Parent=tcl;
ax2.Layout.Tile=3;
ax3.Parent=tcl;
ax3.Layout.Tile=2;
ax4.Parent=tcl;
ax4.Layout.Tile=4;
