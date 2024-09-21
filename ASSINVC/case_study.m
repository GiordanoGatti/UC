clear all
close all
clc

%% The ceramic brick wall
h_ext=0.24;
rho_wall_ext=1280;
mass_wall_ext=h_ext*rho_wall_ext;
% the Rw of the opaque part of all facades
Rw_opaque=50; %simplified method
%the Rw of the sliding windows class A3
R_glass=34;
K_frame=5; 
Rw_window=34-K_frame;

%% walls inside dwellings
% Ceramic brick wall with 0.11m thickness with 0.02 mortar lining at each face
h_concrete=0.02;
rho_concrete=2400;
rho_brick=1280;
h_brick=0.11;
m_wall_inside=rho_brick*h_brick+h_concrete*rho_concrete;
Rw_wall_inside=45;
%% flanking
Rw_slab=58;

%% D2mnTw - Façade of rooms Q4(ap.1), Q2(ap.2)
h_residential=2.58;
W_Q4_Q2=2.70;
L_Q4_Q2=4.70;
L_window_Q4_Q2=1.2;
h_window_Q4_Q2=1.1;
S_facade_Q4_Q2=h_residential*W_Q4_Q2;
S_window_Q4_Q2=h_window_Q4_Q2*L_window_Q4_Q2;
S_opaque_Q4_Q2=S_facade_Q4_Q2-S_window_Q4_Q2;
V=W_Q4_Q2*h_residential*L_Q4_Q2;
T0=0.5;
K=0;
Rw_global_Q4_Q2 = 10*log10(S_facade_Q4_Q2/(S_window_Q4_Q2*10^(-0.1*Rw_window)+S_opaque_Q4_Q2*10^(-0.1*Rw_opaque)))

% D2mnTw of the rooms  Q4(ap.1), Q2(ap.2)
D2mnTw_Q4_Q2 = Rw_global_Q4_Q2-K+10*log10(V/(6.25*T0*S_facade_Q4_Q2)) %No rehablilitation is needed

%% D2mnTw - Façade of room Q1 (ap.2)
Rw_door=Rw_window;
W_Q1=W_Q4_Q2;
L_door_Q1=1.2;
h_door_Q1_Q2=2.1;
S_facade_Q1=h_residential*W_Q1;
S_door_Q1=h_door_Q1_Q2*L_door_Q1;
S_opaque_Q1=S_facade_Q1-S_door_Q1;
L_Q1=L_Q4_Q2;
V=W_Q1*h_residential*L_Q1;
T0=0.5;
K=0;
Rw_global_Q1 = 10*log10(S_facade_Q1/(S_door_Q1*10^(-0.1*Rw_door)+S_opaque_Q1*10^(-0.1*Rw_opaque)))

% D2mnTw of the rooms Q1(ap.2)
D2mnTw_Q1 = Rw_global_Q1-K+10*log10(V/(6.25*T0*S_facade_Q1))  %No rehablilitation is needed

%% D2mnTw - Facade of the Living room (Ap.2)
% Rw globale of LV
Rw_door_lr=Rw_window;
W_lr=3.85;
L_lr=4.85;
V_lr=W_lr*h_residential*L_lr;
L_door_lr=2.4;
h_door_lr=2.1;
S_facade_lr=h_residential*W_lr;
S_door_lr=h_door_lr*L_door_lr;
S_opaque_lr=S_facade_lr-S_door_lr;
T0=0.5;
K=0; % flankings are ignored for facades
Dnew=36;
A0=10;
Rw_globale_lr = 10*log10(S_facade_lr/(S_door_lr*10^(-0.1*Rw_door_lr)+S_opaque_lr*10^(-0.1*Rw_opaque)))
Rw_globale_ventilation=-10*log10(10^(-0.1*Rw_globale_lr)+(A0/S_facade_lr)*10^(-0.1*Dnew))

% D2mnTw of living room
D2mnTw_lr= Rw_globale_ventilation-K+10*log10(V_lr/(6.25*T0*S_facade_lr)) %Rehablilitation is needed

%% D2mnTw - Facade of commercial space (store 1)
R_glass_store=Rw_window;
h_store=3.12;
L_facade_store=9.7;
h_door_store=2.1; 
S_facade_store=h_store*L_facade_store;
S_glass_store=L_facade_store*h_door_store;
S_opaque_store=S_facade_store-S_glass_store;
A_store=96.732; %m²
V_store=h_store*A_store;
T0=0.15*(V_store)^(1/3);
K=0; %flankings are ignored for facades
Rw_globale_store = 10*log10(S_facade_store/(S_glass_store*10^(-0.1*Rw_door)+S_opaque_store*10^(-0.1*Rw_opaque)))
% D2mnTw of facade of the store
D2mnTw_store= Rw_globale_store-K+10*log10(V_store/(6.25*T0*S_facade_store))  %No rehablilitation is needed

%% DnTw - Wall between the common area and the kitchen (T4E) 
% Double brick wall 0.11m+0.11m with mineral wool in the airgap
% with mortar lining at both surfaces with 0.02m 
Rw_common_wall=50; % the slide 33 AIRBORNE SOUND INSULATION
L_common_wall=4.7;
S_common_wall=h_residential*L_common_wall;
L_kitchen=2.85;
V_kitchen=S_common_wall*L_kitchen;
T0=0.5;
K=4; 

%DnTw of and the kitchen of T4E 
Dntw_common_wall= Rw_common_wall-K+10*log10(V_kitchen/(6.25*T0*S_common_wall)) %No rehablilitation is needed

%% DnTw - entrance wall (T2D)
% % Double brick wall 0.11m+0.11m with mineral wool in the airgap
% % with mortar lining at both surfaces with 0.02m 
%Rw_common_wall=50; % the slide 33 AIRBORNE SOUND INSULATION
%double leaf doors fire rated EI30: Rw= 27dB
%Rw_wooden_door = 27; % https://www.dfm-europe.eu/products/wooden-fire-resistant-doors/
%L_common_wall=1.8; %T2D
%L_door_common=0.90;
%h_door_common=2;
%S_common_wall=h_residential*L_common_wall;
%S_door_common=L_door_common*h_door_common;
%S_opaque_common=S_common_wall-S_door_common;
%L_space=2.7;
%W_space=1.85;
%V_space=h_residential*L_space*W_space;
%T0=0.5;
%Rw_common_with_door = 10*log10(S_common_wall/(S_door_common*10^(-0.1*Rw_wooden_door)+S_opaque_common*10^(-0.1*Rw_common_wall)))
% DnTw of the wall with doors T4E and T2D
%K=0; % depends on Rw_common_with_door
%Dntw_common_with_door= Rw_common_with_door-K+10*log10(V_space/(6.25*T0*S_common_wall)) %Rehablilitation is needed

%% DnTw - Wall between the common area and the Living room (T4E)
% Double brick wall 0.11m+0.11m with mineral wool in the airgap
% with mortar lining at both surfaces with 0.02m 
Rw_common_wall=50; % the slide 33 AIRBORNE SOUND INSULATION
L_common_wall=0.7;
S_common_wall=h_residential*L_common_wall;
T0=0.5;
V_lr=W_lr*h_residential*L_lr;
K=4; % depends on Rw_common_wall

% DnTw of living room
Dntw_common_lr= Rw_common_wall-K+10*log10(V_lr/(6.25*T0*S_common_wall)) %No rehablilitation is needed

%% DnTw - Wall between the  living room (T4E) and the bed room (T2D)
% Double brick wall 0.15m+0.11m with mortar lining at both surfaces with 0.02m 
rho_brick=1280;
rho_mortar=2000;
h_brick=0.15+0.11;
h_mortar=2*0.02;
m_brick_wall=rho_brick*h_brick+h_mortar*rho_mortar;
Rw_between_dwellings=49; % based on the simple approach 
Rw_between_dwellings=Rw_between_dwellings+4; % double wall
K=4; % depends on Rw_between_dwellings
L_between_dwellings=1.2;
h_between_dwellings=h_residential;
S_between_dwellings= h_between_dwellings*L_between_dwellings;

% the worst case is from based on the V/S ratio is from the living room to
% the bedroom
Dntw_between_dwellings= Rw_between_dwellings-K+10*log10(V/(6.25*T0*S_between_dwellings)) %No rehablilitation is needed

%% Lntw - Slab between two bed rooms (Q4-T4E and Q2 T2D) of two differnt floors.
h_concrete=0.3;
rho_concrete=2400;
m_screed=100;
m_concrete=h_concrete*rho_concrete;
m_slab=m_concrete+m_screed;
T0=0.5;

Lntw_slab_up_down=169-35*log10(m_slab)-10*log10(0.016*V/T0) %Rehablilitation is needed

%% Lntw - Slab between commercial space and dwelling
LER=2*2.7+2*4.7% The total length of the junctions
Lntw0=76-11*log10(m_slab)+12*log10(LER)
K=8; % depends on Lntw0
DLw=0; % The ceramic directly glued to the slab

LnTw_store_room=Lntw0-(DLw-K) %Rehablilitation is needed

%% Lntw (lateral) - Slab between common area and a dwelling
DLw=0; % The ceramic directly glued to the slab
d=2.8; %distance between common space and Q4 of T4E

LnTw_lateral=123-20*log10(m_slab)-10*log10(d)-DLw %Rehablilitation is needed

%% Lntw (lateral) - Slab between dwellings
DLw=0; % The cermaic directly glued to the slab
d=3.85; %distance between Q4 of T4E and Q1 of T2E

LnTw_lateral=123-20*log10(m_slab)-10*log10(d)-DLw %No rehablilitation is needed

%% DnTw - Wall betwen the elevator and entrance area (T2D)
% Concrete 0.25m thick 
h_concrete=0.25;
rho_concrete=2400;
m_elevator_wall=h_concrete*rho_concrete;
Rw_elevator=54 % based on the simple approach 
K=4; % depends on Rw_between_dwellings
L_elevator=1.7;
h_elevator=h_residential;
S_wall_elevator= h_elevator*L_elevator;
V_entrance = 1.85*2.7*h_residential; 
T0=0.5;

Dntw_elevator= Rw_elevator-K+10*log10(V_entrance/(6.25*T0*S_wall_elevator)) %Rehabilitation is needed
