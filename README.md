# ☀️ FPGA 기반 태양광 추적 시스템 (Sun Tracker)

## 📌 프로젝트 소개

Basys3 FPGA와 Verilog HDL을 이용하여 구현한 **태양광 추적 시스템(Sun Tracker)** 입니다.

두 개의 CdS 조도 센서를 통해 빛의 세기를 측정하고, Xilinx XADC를 이용하여 디지털 데이터로 변환한 뒤 좌우 밝기를 비교하여 서보모터를 자동으로 회전시킵니다.

센서 노이즈를 줄이기 위해 이동평균 필터(Moving Average Filter)를 적용하였으며, 센서 간 편차를 보정하기 위한 Offset Correction 기능도 구현하였습니다.

---

# 📌 개발 환경

| 항목 | 내용 |
|------|------|
| Language | Verilog HDL |
| FPGA | Digilent Basys3 (Artix-7 XC7A35T) |
| Tool | Vivado |
| ADC | Xilinx XADC Primitive |
| Sensor | CdS Photoresistor ×2 |
| Actuator | SG90 Servo Motor |

---

# 📌 주요 기능

- Xilinx XADC Primitive 직접 제어
- CdS 센서를 이용한 조도 측정
- 이동평균 필터를 이용한 노이즈 제거
- Offset Correction을 통한 센서 보정
- FSM 기반 태양광 추적 알고리즘
- Servo PWM 생성 및 제어
- LED를 이용한 조도 표시
- FND를 이용한 센서값 표시
- Fake XADC를 이용한 시뮬레이션

---

# 📌 시스템 구성

```
CdS Sensor
      │
      ▼
 XADC Primitive
      │
      ▼
XADC Controller
      │
      ▼
 Moving Average Filter
      │
      ▼
 Offset Corrector
      │
      ▼
 Brightness Compare
      │
      ▼
 Sun Tracker FSM
      │
      ▼
 Angle → PWM
      │
      ▼
 Servo Motor

      ├── LED Display
      └── FND Display
```

---

# 📌 프로젝트 구조

```
SunTracker
│
├── rtl
│   ├── top.v
│   ├── xadc_core.v
│   ├── xadc_controller.v
│   ├── cds_filter.v
│   ├── offset_corrector.v
│   ├── sun_tracker_fsm.v
│   ├── angle_to_pwm.v
│   ├── pwm_generator.v
│   ├── brightness_led.v
│   ├── fnd_display.v
│   └── tick_generator.v
│
├── tb
│   ├── fake_xadc.v
│   └── top_tb.v
│
├── constraints
│   └── Basys3.xdc
│
└── README.md
```

---

# 📌 모듈 설명

| 모듈 | 설명 |
|------|------|
| top | 전체 시스템 통합 |
| xadc_core | XADC Primitive 인터페이스 |
| xadc_controller | XADC 채널(CH6, CH7) 데이터 읽기 |
| cds_filter | 8샘플 이동평균 필터 |
| offset_corrector | 센서 Offset 보정 |
| sun_tracker_fsm | 태양광 추적 FSM |
| angle_to_pwm | 각도를 PWM 펄스폭으로 변환 |
| pwm_generator | 서보모터 PWM 생성 |
| brightness_led | 조도 레벨 LED 표시 |
| fnd_display | 센서값 FND 출력 |
| tick_generator | 주기적인 샘플링 Tick 생성 |
| fake_xadc | 시뮬레이션용 XADC 모델 |
| top_tb | 전체 시스템 Testbench |

---

# 📌 동작 과정

1. XADC를 통해 좌·우 CdS 센서 값을 읽는다.
2. 이동평균 필터를 적용하여 노이즈를 제거한다.
3. Offset Correction으로 센서 편차를 보정한다.
4. 좌우 밝기를 비교한다.
5. 차이가 임계값 이상이면 FSM이 서보모터 회전 방향을 결정한다.
6. PWM 신호를 생성하여 서보모터를 제어한다.
7. LED와 FND에 현재 센서 상태를 표시한다.

---

# 📌 구현 특징

- XADC Wizard를 사용하지 않고 **Xilinx XADC Primitive를 직접 사용**
- DRP 인터페이스를 FSM으로 직접 구현
- 이동평균 필터를 적용하여 센서 노이즈 감소
- Offset 보정을 통해 센서 오차 최소화
- 실제 하드웨어와 동일한 환경을 위해 Fake XADC 기반 시뮬레이션 수행

---

# 📌 향후 개선 사항

- 자동 Offset Calibration
- 야간 감지(Night Mode)
- 추적 속도 자동 조절
- PID 제어 적용
- 태양광 발전량 모니터링 기능 추가
