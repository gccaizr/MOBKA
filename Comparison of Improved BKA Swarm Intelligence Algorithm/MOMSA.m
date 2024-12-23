%% Multi-objective Mantis Search Algorithm (MOMSA): A Novel Approach for Engineering Design Problems and Validation
%  Developed in MATLAB R2019a
%%Author and programmer: Mohjameel (E-mail:  moh.jameel@su.edu.ye; Mohjameel555@gmail.com)
function f = MOMSA(params,MultiObj)
name=MultiObj.name;%问题名
M=MultiObj.numOfObj;%目标函数个数
fobj=MultiObj.fun;
dim=MultiObj.nVar;
lb=MultiObj.var_min;
ub=MultiObj.var_max;
Max_iter = params.maxgen;  % Set the maximum number of generation (GEN)
SearchAgents_no = params.Np;      % Set the population size (Search Agent)
ishow = 1;


%%-------------------Controlling parameters--------------------------%%
p=0.5;   %% A probability to exchange between the exploration and exploitation stages
A=1.0;   %% Length of the archive
a=0.5;   %% A probability of the strike抯 failure
P=2;     %% A recycling factor to exchange between pursuers and spearers
alp=6; %% The gravitational acceleration rate of the mantis抯 strike
Pc=0.2;  %% The percentage of sexual cannibalism
archive=[[]]; %% an archive to include the positions of a number of camouflaged places
Positions = zeros(SearchAgents_no,dim);
Sol = zeros(SearchAgents_no,dim);
%%  START  THE  EXECUTION  OF  THE  MOMSA ALGORITHM
%% Initialize the population
for i=1:SearchAgents_no
    Positions(i,:)=lb+(ub-lb).*rand(1,dim);
    f(i,1:M) = fobj(Positions(i,:));
end
new_Sol=[Positions f];
new_Sol = solutions_sorting(new_Sol, M, dim);
%% The main loop of MOMSA algorithm
for t = 1 : Max_iter
    RL=0.05*levy(SearchAgents_no,dim,1.5);   %Levy random number vector
    a2=-1+-1*(t/Max_iter); %% a2 linearly decreases from -1 to -2
    for i=1:SearchAgents_no
        l=(a2-1)*rand+1; %% a Factor including a numerical value between ?1 and -2 to control the gravitational acceleration rate
        best=  (new_Sol(i,1:(dim)) - new_Sol(1,(1:dim)));
        if (size(archive,1)<A) %% Adding directly to the archive if it is not full; otherwise, remove an existing one selected randomly.
            archive=best;
        else
            archive(randi(A),:)=best;
        end
        
        % %       bA= archive;
        bA=archive(randi(size(archive,1)),1:dim); %% Selecting randomly a solution from the archive
        a1=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
        b=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
        c=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
        while a1==i | a1==b | c==b | c==a1 ||c==i |b==i %% Checking that a1!=b!=c!=i; if the same index is selected twice or more, the following code is applied repeatedly to satisfy this constraint:
            a1=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
            b=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
            c=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
        end
        r1=rand(); % r1 is a random number in [0,1]
        r2=rand(); % r2 is a random number in [0,1]
        r3=rand(); % r1 is a random number in [0,1]
        t2=randn;  % t2 is a normal distribution-based number
        m=1-t/Max_iter; % Eq. (7)
        
        if (rand<p) %% Exchanging between exploration and exploitation
            F=1-rem(t,Max_iter/P)/(Max_iter/P);  % Eq. (11)
            U=rand(1,dim)>rand(1,dim); % A binary vector generated based on Eq. (4).
            for j=1:size(Positions,2)
                if r1<F %% Exploration of pursuers? behavior
                    if r2<r3
                        Steps=(Positions(i,j)-Positions(a1,j))*RL(i,j)+abs(t2)*U(j)*(Positions(a1,j)- Positions(b,j)); % Eq. (3a)
                        Positions(i,j)= Positions(i,j)+Steps;
                    else
                        y = Positions(a1,j)+rand.*(Positions(b,j)-Positions(c,j));
                        if rand<=rand %% Merging the characteristics of the new solution and the current one to simulate sudden orientation for the ith mantis
                            Positions(i,j)=y;
                        end
                    end
                else %% Exploration of spearers? behavior
                    if r2<r3
                        alpha=cos(pi*rand)*m;
                        Positions(i,j)=Positions(i,j)+alpha*(bA(j)-Positions(b,j));
                    else
                        Positions(i,j)=(bA(j))+(r2*2-1)*m*(lb(j)+rand*(ub(j)- lb(j)));
                    end
                end
            end
        else %% Attacking the prey: Exploitation stage
            Best_P=(new_Sol(i,1:(dim)) - new_Sol(1,(1:dim)));
            for j=1:size(Positions,2)
                if rand<r2
                    Positions(i,j)=Positions(i,j)+r1*(Positions(a1,j)-Positions(b,j));
                else
                    vs=1/(1+exp(alp*l));
                    dsi=Best_P(j)-Positions(i,j);
                    Positions(i,j)=(Positions(i,j)+Best_P(j))/2.0+vs*dsi;
                    Pf=a*(1-t/Max_iter);
                    if r2<Pf
                        Positions(i,j)=(Positions(i,j))+exp(2*l)*cos(2*l*pi)*abs(Positions(i,j)-bA(j))+(rand*2-1)*(ub(j)-lb(j));
                    end
                end
            end
        end
        for j=1:size(Positions,2)
            if  Positions(i,j)>ub(j)
                Positions(i,j)=lb(j)+rand*(ub(j)-lb(j));
            elseif  Positions(i,j)<lb(j)
                Positions(i,j)=lb(j)+rand*(ub(j)-lb(j));
            end
        end
        %%%%%%Return the search agents that exceed the search space's bounds
        Sol(i,1:dim) = Positions(i,1:dim);
        for j=1:size(Positions,2)
            if  Sol(i,j)>ub(j)
                Sol(i,j)=lb(j)+rand*(ub(j)-lb(j));
            elseif  Sol(i,j)<lb(j)
                Sol(i,j)=lb(j)+rand*(ub(j)-lb(j));
            end
        end
        %% Evalute the fitness/function values of the new population
        Sol(i, dim+1:M+dim) = fobj(Sol(i,1:dim));
        if Sol(i,dim+1:dim+M) <= new_Sol(1,(dim+1:dim+M))
            new_Sol(1,1:(dim+M)) = Sol(i,1:(dim+M));
        end
        Positions(i,1:dim)=  new_Sol(i,1:dim);
    end
    
    if rand<Pc
        % Update the Position of search agents
        for i=1:SearchAgents_no
            l=(a2-1)*rand+1;
            r1=rand(); % r1 is a random number in [0,1]
            r3=rand(); % r3 is a random number in [0,1]
            if rand<rand
                U=rand(1,dim)>rand(1,dim); % A binary vector generated based on Eq. (4).
                for j=1:size(Positions,2)
                    Positions(i,j)= Positions(i,j)*U(j)+(Positions(1,1)+-rand*(-Positions(1,1)+Positions(i,j))).*(1-U(j)); % Eq. (21)
                end
            else
                a1=randi(SearchAgents_no);
                while a1==i
                    a1=randi(SearchAgents_no);
                end
                Pt=r2*(1-t/Max_iter);
                for j=1:size(Positions,2)
                    if r1<Pt
                        Positions(i,j)= Positions(i,j)+r3*(Positions(i,j)- Positions(a1,j));
                        Positions(i,j)=Positions(a1,j)*cos(l*pi*2)*m;
                    end
                end
            end
            %%%%%%Return the search agents that exceed the search space's bounds
            Sol(i,1:dim) = Positions(i,1:dim);
            for j=1:size(Positions,2)
                if  Sol(i,j)>ub(j)
                    Sol(i,j)=lb(j)+rand*(ub(j)-lb(j));
                elseif  Sol(i,j)<lb(j)
                    Sol(i,j)=lb(j)+rand*(ub(j)-lb(j));
                end
            end
            %% Evalute the fitness/function values of the new population
            Sol(i, dim+1:M+dim) = fobj(Sol(i,1:dim));
            if Sol(i,dim+1:dim+M) <= new_Sol(1,(dim+1:dim+M))
                new_Sol(1,1:(dim+M)) = Sol(i,1:(dim+M));
            end
        end
    end
    %% ! Very important to combine old and new bats !
    Sort_bats(1:SearchAgents_no,:) = new_Sol;
    Sort_bats((SearchAgents_no + 1):(2*SearchAgents_no), 1:M+dim) = Sol;
    %% Non-dominated sorting process (a separate function/subroutine)
    Sorted_bats = solutions_sorting(Sort_bats, M, dim);
    %% Select npop solutions among a combined population of 2*npop solutions
    new_Sol = cleanup_batspop(Sorted_bats, M, dim, SearchAgents_no);
    % if rem(t, ishow) == 0
    %     fprintf('Generation: %d\n',t);
    % end
    %    % Plot Pareto Front
    % h_fig = figure(1);
    % 
    % if(M==2)
    %     pl_data= new_Sol(:,dim+1:dim+M); % extract data to plot
    %     POS_fit=sortrows(pl_data,2);
    %     figure(h_fig);
    % 
    %     h_par = plot(POS_fit(:,1),POS_fit(:,2),'ok'); hold on;
    %     if(isfield(MultiObj,'truePF'))
    % 
    %         h_pf = plot(MultiObj.truePF(:,1),MultiObj.truePF(:,2),'.r'); hold on;
    %     end
    %     title(name);
    %     grid on; xlabel('f1'); ylabel('f2');
    %     drawnow;
    %     hold off
    % end
    % if(M==3)
    %     pl_data=  new_Sol(:,dim+1:dim+M); % extract data to plot
    %     POS_fit=sortrows(pl_data,3);
    %     figure(h_fig);
    %     h_par = plot3(POS_fit(:,1),POS_fit(:,2),POS_fit(:,3),'ok'); hold on;
    %     if(isfield(MultiObj,'truePF'))
    %         h_pf = plot3(MultiObj.truePF(:,1),MultiObj.truePF(:,2),MultiObj.truePF(:,3),'.r'); hold on;
    %     end
    %     title(name);
    %     grid on; xlabel('f1'); ylabel('f2'); zlabel('f3');
    %     drawnow;
    %     hold off
    % end
end
% hold off;
% if(isfield(MultiObj,'truePF'))
%     legend('MOMSA','TruePF');
% else
%     legend('MOMSA');
% end


f=new_Sol;
end
%% Clean up the populations (both old and new) to give a new population
% This cleanup here is similar to the Non-dominated Sorting Genetic
% Algorithm (NSGA-II) by K. Deb et al. (2002), which can be applied to
% any cleanup of 2*npop solutions to form a set of npop solutions.
function new_bats = cleanup_batspop(bats, m, ndim, npop)
% The input population to this part has twice (ntwice) of the needed
% population size (npop). Thus, selection is done based on ranking and
% crowding distances, calculated from the non-dominated sorting
ntwice= size(bats,1);
% Ranking is stored in column Krank
Krank=m+ndim+1;
% Sort the population of size 2*npop according to their ranks
[~,Index] = sort(bats(:,Krank)); sorted_bats=bats(Index,:);
% Get the maximum rank among the population
RankMax=max(bats(:,Krank));

%% Main loop for selecting solutions based on ranks and crowding distances
K = 0;  % Initialization for the rank counter
% Loop over all ranks in the population
for i =1:RankMax,
    % Obtain the current rank i from sorted solutions
    RankSol = max(find(sorted_bats(:, Krank) == i));
    % In the new bats/solutions, there can be npop solutions to fill
    if RankSol<npop,
        new_bats(K+1:RankSol,:)=sorted_bats(K+1:RankSol,:);
    end
    % If the population after addition is large than npop, re-arrangement
    % or selection is carried out
    if RankSol>=npop
        % Sort/Select the solutions with the current rank
        candidate_bats = sorted_bats(K + 1 : RankSol, :);
        [~,tmp_Rank]=sort(candidate_bats(:,Krank+1),'descend');
        % Fill the rest (npop-K) bats/solutions up to npop solutions
        for j = 1:(npop-K),
            new_bats(K+j,:)=candidate_bats(tmp_Rank(j),:);
        end
    end
    % Record and update the current rank after adding new bats
    K = RankSol;
end
end

function [z] = levy(n,m,beta)

num = gamma(1+beta)*sin(pi*beta/2); % used for Numerator

den = gamma((1+beta)/2)*beta*2^((beta-1)/2); % used for Denominator

sigma_u = (num/den)^(1/beta);% Standard deviation

u = random('Normal',0,sigma_u,n,m);

v = random('Normal',0,1,n,m);

z =u./(abs(v).^(1/beta));


end

%% The sorting of nondomninated solutions from a population of 2*npop     %
%% (New solutions+old population) to form a population of npop solutions  %
function sorted_x = solutions_sorting(x, m, ndim)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inputs and outputs are the extended solutions x with a dimension of    %
%% npop by (ndim+m+2). The objective values are already included in x.    %
% More specifically, the first ndim columns are the actual solutions or
% variable values (1:ndim), followed by the m columns of objective values.
% Then, the next column (i.e.,ndim+m+1) corresponds to the ranks, whereas
% the final column (i.e., ndim+m+2) records the crowd distances.
% ----------------------------------------------------------------------- %
%% Get the parameters from the inputs such as the size of input population
npop=size(x,1);    % Population size
frontRank=1;       % Pareto frontRank (counter) initialization
Rcol=ndim+m+1;     % Store the ranks in the column Rcol=ndim+m+1
% Define the Parato Front as a class (PF) and initilization of xSol
PF(frontRank).R=[];   xSol=[];
%% The main non-dominated sorting starts here             %%%%%%%%%%%%%%%%%
for i = 1:npop,
    % Set the number (initially, 0) of solutions dominating this solution
    xSol(i).n=0;
    % Find all the solutions (that dominated by this solution)
    xSol(i).q=[];
    % Sorting into 3 categories: better (minimization), equal & otherwise
    for j=1:npop,
        % Definte 3 counters for 3 categories
        ns_categ_1=0; ns_categ_2=0; ns_categ_3=0;
        for k=1:m,  % for all m objectives
            % Update the counters for 3 different categories
            if (x(i,ndim+k) < x(j,ndim+k)),      % better/non-dominated
                ns_categ_1=ns_categ_1+1;
            elseif (x(i,ndim+k)==x(j,ndim+k)),   % equal
                ns_categ_2=ns_categ_2+1;
            else                                 % dominated
                ns_categ_3=ns_categ_3+1;
            end
        end % end of k
        % Update the solutions in their class
        if ns_categ_1==0 && ns_categ_2 ~= m
            xSol(i).n=xSol(i).n+1;
        elseif ns_categ_3 == 0 && ns_categ_2 ~= m
            xSol(i).q=[xSol(i).q j];
        end
    end % end of j
    %% Record/Udpate the Pareto Front
    if xSol(i).n==0,
        x(i,Rcol)=1;   % Update the Rank #1 (i.e., the Pareto Front)
        PF(frontRank).R = [PF(frontRank).R i];
    end
end % end of i=1:npop (The first round full rank-sorting process)

% Update the rest frontRanks (close, but not on the Pareto Front)
while ~isempty(PF(frontRank).R),
    nonPF=[];    % Intialization the set
    N=length(PF(frontRank).R);
    for i=1 :N,
        % Get the solution/list
        Sol_tmp_q=xSol(PF(frontRank).R(i)).q;
        % If not empty, update
        if ~isempty(xSol(Sol_tmp_q))
            for j = 1:length(Sol_tmp_q),
                % Get the solutions dominated by the current solution
                Sol_tmp_qj=xSol(PF(frontRank).R(i)).q(j);
                xSol(Sol_tmp_qj).n=xSol(Sol_tmp_qj).n-1;
                if xSol(Sol_tmp_qj).n==0
                    x(Sol_tmp_qj, Rcol)=frontRank + 1;
                    nonPF = [nonPF Sol_tmp_qj];
                end
            end % end of j
        end
    end  % end of i
    frontRank=frontRank+1;
    PF(frontRank).R=nonPF;
end % end of PF(frontRank)

% Now carry out the sorting of ranks and then update
[~,frontRanks_Index]=sort(x(:, Rcol));
Sorted_frontRank=x(frontRanks_Index,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Evaluate the crowding distances for each solution for each frontRank   %
% That is, all the non-domonated solutions on the Pareto Front.  %%%%%%%%%%
Qi=0;      % Initialize a counter
for frontRank=1:(length(PF)-1),
    % Define/initialize a generalized distance matrix
    dc = [];    past_Q=Qi+1;
    for i=1:length(PF(frontRank).R),
        dc(i,:)=Sorted_frontRank(Qi+i,:);
    end
    Qi=Qi+i;
    % Solutions are sorted according to their fitness/objective values
    fobj_sorted=[];
    for i=1:m,
        [~, f_Rank]=sort(dc(:,ndim+i));
        fobj_sorted=dc(f_Rank,:);
        % Find the max and min of the fobj values
        fobj_max=fobj_sorted(length(f_Rank), ndim+i);
        fobj_min=fobj_sorted(1, ndim+i);
        % Calculate the range of the fobj
        f_range=fobj_max-fobj_min;
        % If the solution is at the end/edge, set its distance as infinity
        dc(f_Rank(length(f_Rank)), Rcol+i)=Inf;
        dc(f_Rank(1), Rcol+i) = Inf;
        for j=2:length(f_Rank)-1,
            fobj2=fobj_sorted(j+1,ndim + i);
            fobj1=fobj_sorted(j-1,ndim + i);
            % Check the range or special cases
            if (f_range==0),
                dc(f_Rank(j), Rcol+i)=Inf;
            else
                % Scale the range for distance normalization
                dc(f_Rank(j),Rcol+i)=(fobj2-fobj1)/f_range;
            end
        end % end of j
    end % end of i
    
    % Calculate and update the crowding distances on the Pareto Front
    dist = []; dist(:,1)=zeros(length(PF(frontRank).R),1);
    for i=1:m,
        dist(:,1)=dist(:,1)+dc(:, Rcol+i);
    end
    % Store the crowding distrance (dc) in the column of Rcol+1=ndim+m+2
    dc(:, Rcol+1)=dist;  dc=dc(:,1:Rcol+1);
    % Update for the output
    xy(past_Q:Qi,:)=dc;
end  % end of all ranks search/update
sorted_x=xy();    % Output the sorted solutions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end of non-dominated sorting %%%%%%%%%%%%%%
end

