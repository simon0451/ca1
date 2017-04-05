%% Header 
% Simon Popecki
% ME 603
% Computing Assignment 1
% 5 April 2017
% See notes from 16 March 2017

clear all;
close all;

%% Gathering Information From the User

prompt = 'Enter the left side boundary condition temperature (°C): '; %asking the user for the left side temperature - McHugh will enter 100 deg. C
Tleft = input(prompt); %the left side temperature (deg. C)

prompt = 'Enter the right side boundary condition temperature (°C): '; %asking the user for the right side temperature - McHugh will enter 200 deg. C
Tright = input(prompt); %the right side temperature (deg. C)


prompt = 'Enter the distance between the two boundaries in centimeters: '; %asking the user to give a distance between the left and right side temperatures - this is used to determine the length {Delta}x - the distance between each node
distance = input(prompt); %the distance between the two inputted temperature points (cm)

prompt = 'Enter desired number of nodes: '; %asking the user for the number of gridpoints
nodes = input(prompt); %the user inputted number of nodes/gridpoints

Deltax = distance/nodes; %the distance between nodes (cm)

nodeDistance = 'The distance between nodes in centimeters is: '; %a string variable for the user to understand when displayed
disp(nodeDistance) %displaying the explanatory string
disp(Deltax) %displaying the actual calculated value

%% Matrix Preparation

A = zeros(nodes); %preallocating an n by n matrix of zeros

for i = 2:(nodes-1)
  A(i,i) = -2; %from notes - the middle diagonal except the top left and bottom right corners needs to be -2
  A(i,i+1) = 1; %from notes - this is the top right diagonal, and is 1 for every value (must be 1 to account for boundary conditions)
  A(i,i-1) = 1; %from notes - this is the bottom left diagonal, and is also 1 for the same reason
end

% Defining the top left and bottom right corners of the A matrix (outside the for loop to improve efficiency)
A(1,1) = 1; %the top left position
A(end,end) = 1; %the bottom right position

b = zeros(nodes,1); %initializing the 'b' array with zeros for the entire length
b(1) = Tleft; %inputting the left side temperature as the top value in the column vector
b(end) = Tright; %inputting the right side temperature as the bottom value in the column vector

%% Matrix Solving

Tdist = McAB(A,b); %solving the system of equations to generate a column vector of temperature distribution by inputting the values into a solving function

plottingDistance = 0:Deltax:distance; %creating discretized points which correspond to the temperature distribution array (Tdist), units are meters
plottingDistance = plottingDistance(1:end-1); %fixing off by one error - there can only be one Deltax for every temperature value in Tdist

%% Output Results to ASCII File

dlmwrite('TemperatureData',Tdist,'newline','pc') %writing the data to an ASCII delimited file
disp('Warning: Unix based systems may have issues reading newline delimited files, change "pc" to "unix" in line 59 if you are using Unix or Linux') %warning unix/linux users that their data might be difficult to read
disp('Temperature data saved, first/top number in file is left boundary condition, filename: TemperatureData') %explaning to user that the data were saved, and where to find them

%% Plotting Results

figure(1)
plot(plottingDistance,Tdist,'o')
title('Temperature Distribution Between Two Point Temperatures')
xlabel('Position in Medium (left B.C. = 0) (cm)')
ylabel('Temperature (°C)')
grid on

print(figure(1),'TemperatureDistributionPlot','-dpdf') %saving the plot as a .pdf
disp('Plot saved, filename: TemperatureDistributionPlot.pdf') %telling the user that the plot was saved









