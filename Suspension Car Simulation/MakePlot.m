% Cara Plot Menggunakan Script Dari Simulink %
clf, clc 

figure(1)
plot(out.Y1.time, out.Y1.signals.values)
xlabel('Time (s)')
ylabel('Suspension Deflection (m)')
title('Control Suspension Output')

figure(2)
plot(out.Bumb.time, out.Bumb.signals.values)
xlabel('Time (s)')
ylabel('Bump (cm)')
title('Bump Road Input')

figure(3)
plot(out.dy_dtX1.time, out.dy_dtX1.signals.values)
xlabel('Time (s)')
ylabel('Velocity Spring Mass (cm/s)')
title('Velocity Spring Mass')

figure(4)
plot(out.X1.time, out.X1.signals.values)
xlabel('Time (s)')
ylabel('Tire Deflection (cm)')
title('Tire Deflection')

figure(5)
plot(out.dy_dtY1.time, out.dy_dtY1.signals.values)
xlabel('Time (s)')
ylabel('Velocity Unspring Mass (cm/s)')
title('Velocity Unspring Mass')

figure(6)
plot(out.Open.time, out.Open.signals.values)
xlabel('Time (s)')
ylabel('Suspension Deflection (m)')
title('Suspension Deflection Open Loop')