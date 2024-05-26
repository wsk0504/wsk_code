clc; clear; close all
% CSV 파일 경로 설정
filename = '20240412_222753.csv';

% CSV 파일 읽기 (헤더 포함)
data = readtable(filename);
// sedgfsdfgsdfgsdfg

% Time, PWM, Weight 데이터 추출
time = data.Time;
pwm = data.PWM;
weight = data.Weight;

time = time - time(1);

% time = medfilt1(time,10);
% pwm = medfilt1(pwm,10);

% 데이터에서 사분위수 계산
weightQ1 = quantile(weight, 0.25);
weightQ3 = quantile(weight, 0.75);
weightIQR = weightQ3 - weightQ1;

% 이상치 제거 기준 설정
weightlowerBound = weightQ1 - 1.5 * weightIQR;
weightupperBound = weightQ3 + 1.5 * weightIQR;

% 이상치를 제외한 데이터 인덱스 찾기
weight_validIdx = (weight > weightlowerBound) & (weight < weightupperBound);


% 이상치가 제거된 데이터 추출
weightfilteredTime = time(weight_validIdx);
weightfilteredPWM = pwm(weight_validIdx);
weightfilteredWeight  = weight(weight_validIdx);


% weightfilteredTime = time;
% weightfilteredPWM = pwm;
% weightfilteredWeight  = weight;

% weightfilteredWeight = medfilt1(weightfilteredWeight,10);

% PWM-Weight 그래프 생성
figure(1);

% Weight 데이터를 왼쪽 y축에 플로팅
yyaxis left;
plot(weightfilteredTime, weightfilteredWeight, 'r-', 'DisplayName', 'Weight');
ylabel('Weight(g)', 'FontSize', 16);
set(gca, 'ycolor', 'r');  % y축 색상 설정

% PWM 데이터를 오른쪽 y축에 플로팅
yyaxis right;
plot(weightfilteredTime, weightfilteredPWM, 'b-', 'DisplayName', 'PWM');
ylabel('PWM', 'FontSize', 16);
set(gca, 'ycolor', 'b');  % y축 색상 설정

% 그래프 제목과 x축 라벨 설정
title('Filtered PWM and Weight over Time', 'FontSize', 16);
xlabel('Time (s)', 'FontSize', 16);

% 범례 표시
legend('show', 'FontSize', 16);

% 그리드 활성화
grid on;
