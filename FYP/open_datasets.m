%% visualise

clear;close all
filename = 'DB1_s1/S1_A1_E1.mat';
load(filename);

% action number
action = 1;

% extract time points for 1 action
start_time = find(stimulus>0,1);
end_time = find(stimulus>1,1);

% % specific
%start_time = 3700
%end_time = 4000

start = start_time/90
endi = end_time/90

% extract 1st section where stimulus=1
% start_time = find(stimulus==action, 1);
% end_time = start_time + find(stimulus(start_time:length(stimulus))==0, 1);

sampling_rate = 90; % records/sec
size = (1:length(glove))* 1/sampling_rate;

% from 'repetition', each action is repeated 10 times
figure
subplot(2,2,1)
plot(size, stimulus);
xlabel('Time / s','FontSize',28);
ylabel('Action number','FontSize',28)
title('Action number (stimulus)', 'FontSize', 32);
%xlim([start endi])
%ylim([0 1.5]);
ax = gca;
ax.FontSize = 24; 
xline([start, endi], '--','LineWidth',3.0)
xline([3700/90, 4000/90], 'g--','LineWidth',3.0)

% Index finger
subplot(2,2,3)
plot(size, glove(:, 5),'LineWidth',3.0) % metacarpophalangeal joint
hold on
plot(size, glove(:,6),'LineWidth',3.0) % proximal interphalangeal joint
hold on
plot(size, glove(:, 7),'LineWidth',3.0) % distal interphalangeal joint
title('Joint angles (glove)', 'FontSize', 32);
xline([3700/90, 4000/90], 'g--','LineWidth',3.0)

ax = gca;
ax.FontSize = 24; 
%legend('joint 5', 'joint 6', 'joint 7', 'Location','best','FontSize',24)
% legend('Metacarpophalangeal joint', 'Proximal interphalangeal joint', ...
%     'Distal interphalangeal joint');
xline([start, endi], '--', 'HandleVisibility','off','LineWidth',3)
%xlim([start, endi])
xlabel('Time / s','FontSize',28)
ylabel('Angle / degrees','FontSize',28)

subplot(2,2,2)
plot(size, stimulus,'LineWidth',3);
xlabel('Time / s','FontSize',28);
ylabel('Action number','FontSize',28)
title('Action number (stimulus)', 'FontSize', 32);
xlim([start endi])
%ylim([0 1.5]);
ax = gca;
ax.FontSize = 24; 
xline([start, endi], '--','LineWidth',3.0)
xline([3700/90, 4000/90], 'g--','LineWidth',3.0)

% Index finger
subplot(2,2,4)
plot(size, glove(:, 5),'LineWidth',3.0) % metacarpophalangeal joint
hold on
plot(size, glove(:,6),'LineWidth',3.0) % proximal interphalangeal joint
hold on
plot(size, glove(:, 7),'LineWidth',3.0) % distal interphalangeal joint
title('Joint angles (glove)', 'FontSize', 32);

ax = gca;
ax.FontSize = 24; 
legend('joint 5', 'joint 6', 'joint 7', 'Location','best','FontSize',24)
% legend('Metacarpophalangeal joint', 'Proximal interphalangeal joint', ...
%     'Distal interphalangeal joint');
xline([start, endi], '--', 'HandleVisibility','off','LineWidth',3)
xlim([start, endi])
xline([3700/90, 4000/90], 'g--','HandleVisibility','off','LineWidth',3.0)
xlabel('Time / s','FontSize',28)
ylabel('Angle / degrees','FontSize',28)

figure
plot(size, glove(:, 5)-glove(1,5),'LineWidth',3.0) % metacarpophalangeal joint
hold on
plot(size, glove(:,6)-glove(1,6),'LineWidth',3.0) % proximal interphalangeal joint
hold on
plot(size, glove(:, 7)-glove(1,7),'LineWidth',3.0) % distal interphalangeal joint
title('Joint angles', 'FontSize', 32);
ax = gca;
ax.FontSize = 24; 
legend('joint 5', 'joint 6', 'joint 7', 'Location','best','FontSize',24)
xlim([3700/90 4000/90])
xlabel('Time / s','FontSize',28)
ylabel('Angle / degrees','FontSize',28)

%% analysis

errors = csvread('error_calcs.csv',2);

% time evolution of calced vs target angle beta
figure
titles = ["$i=5$";"$i=6$";"$i=7$"];
for i=1:3
    j=0.1+i-1;
    subplot(1,3,i)
    plot(errors(:,1),errors(:,i+4),'-x','LineWidth',3.0) 
    hold on
    plot(errors(:,1),errors(:,i+7),'-x','LineWidth',3.0)
    hold on
    title(titles(i), 'FontSize', 32,'Interpreter','Latex');
    ax = gca;
    ax.FontSize = 24; 
    legend('$\beta_{i}$','$\beta_{i,t}$','FontSize',24,'Interpreter','Latex')
    xlabel('Frame number','FontSize',28)
    ylabel('Angle / \circ','FontSize',28)
    axis square
end
sgtitle('Time evolution of calculated ($\beta_{i}$) and target ($\beta_{i,t}$) joint angles','FontSize',36,'Interpreter','Latex')

% Total error vs frame no
figure
plot(errors(:,1),errors(:,2),'-x','LineWidth',3.0)
xlabel('Frame number','FontSize',28)
ylabel('Estimation error','FontSize',28)
title('Total estimation error of joint angles by frame number','FontSize',56,'Interpreter','Latex')
ax = gca;
ax.FontSize = 24; 

%% sample time step for angles

%% S1_E1_A1
% movement E1-1: finger flexion
sample_1 = 3938;
sample_2 = 11390;
ref_1 = 1;
joints = [5 6 7];

%movement E1-2: finger extension
sample_1 = 3938;
sample_2 = 10557;
ref_2 = 12770;
joints = [5 6 7];

% angles of joints 6,7,11 in the middle of the action
angles = zeros(2, 3);

% original angles of joints 6,7,11 at rest
original = zeros(2, 3);

for i=1:length(joints)
    angles(:,i) = [glove(sample_1, joints(i));
    glove(sample_2, joints(i))];
    original(:,i) = [glove(ref_1,joints(i));
        glove(ref_2, joints(i))];
end
angles
original

% %% S1_E1_A2
% 
% %movement E2-8: neutral
% sample_rest = 73193;
% sample_act = 73564;
% joints = [5 6 7];
% 
% angles = zeros(3, 3);
% for i=1:length(joints)
%     angles(:,i) = [glove(sample_rest, joints(i));
%         glove(sample_act, joints(i));
%         glove(sample_rest, joints(i))-glove(sample_act, joints(i))];
% end
% angles
