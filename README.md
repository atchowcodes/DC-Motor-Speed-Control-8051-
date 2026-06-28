# DC Motor Speed Control using 8051 Microcontroller

A password-protected DC motor speed control system implemented on the AT89C52 (8051) microcontroller using Assembly language. Supports bidirectional rotation, PWM-based speed control, and overload protection.

## Overview

This project implements a complete motor control system where users interact via a keypad to control motor speed and direction. The system uses PWM (Pulse Width Modulation) to regulate speed and an L298N H-Bridge driver to interface the microcontroller with the motor.

---

## Features

- 3 predefined speed levels via PWM duty cycle control
- Bidirectional rotation (Clockwise / Anticlockwise)
- Overload protection with buzzer and LED alert
- LCD display showing real-time RPM and direction
- Password protection (6-digit alphanumeric)
- Manual motor stop and restart via keypad

---

## Speed Levels

| Key | Level | Duty Cycle | Estimated RPM |
|-----|-------|------------|---------------|
| 1   | LOW   | 25%        | 500 RPM       |
| 2   | MED   | 50%        | 1000 RPM      |
| 3   | HIGH  | 75%        | 1500 RPM      |
| A   | OVERLOAD | 100%   | 3000 RPM (triggers buzzer) |

---

## Keypad Controls

| Key | Function |
|-----|----------|
| 1 / 2 / 3 | Speed levels (Low / Med / High) |
| ON/C | Clockwise rotation |
| = | Anticlockwise rotation |
| A | Overload simulation |
| 0 | Motor OFF |
| B | Restart |

---

## Circuit Diagram

<img width="1152" height="779" alt="image" src="https://github.com/user-attachments/assets/29e4fe6e-e962-475c-a8b9-e8208a0488eb" />


---

## Working Principle


1. System powers on → LCD displays "SPEED-CONTROLLED DC MOTOR"
2. User enters 6-digit password via keypad
3. Correct password → "MOTOR ACTIVE" displayed
4. User selects speed level and direction
5. Motor runs at selected RPM; LCD shows real-time status
6. If overload key pressed → buzzer sounds, motor shuts down
7. Key "0" stops motor; Key "B" restarts from speed selection

---

## Hardware

<img width="716" height="715" alt="image" src="https://github.com/user-attachments/assets/c839b515-8ad6-42e6-9bb6-4a334f27fed4" />

### Components

| Component | Quantity |
|-----------|----------|
| AT89C52 Microcontroller | 1 |
| L298N H-Bridge Motor Driver | 1 |
| 4V 2000 RPM DC Motor | 2 |
| DC-DC 12V to 3.3V & 5V Power Module | 1 |
| Active Buzzer 5V | 1 |
| 4x4 Keypad | 1 |
| 16x2 LCD Display | 1 |
| Crystal Oscillator | 1 |

---
