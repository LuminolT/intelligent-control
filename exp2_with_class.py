# from tkinter.messagebox import YES
import control as ctl
import matplotlib as plt
import time

class PID():
    
    # --e(t)-->[PID Controller]--(u(t))-->[Plant]--(y(t))-->
    
    def __init__(self, kp: float, ki: float, kd: float, ts: float) -> None:
        
        self._Kp = kp
        self._Ki = ki
        self._Kd = kd
        self._Ts = ts   ## 采样间隔
        
    def process(self, t: float, set_point: float, et: list[list[float]], y: list[float], u: list[float], is_expert=False):
        
        ## et: error table
        
        output_u = self._Kp*et[-1][0] + self._Ki*et[-1][1] + self._Kd*et[-1][2]
        
        if is_expert:
            ## Expert PID Controller
            
            ## Rule 1. Open-loop
            if abs(et[-1][0]) > 0.8:
                output_u = 0.45
            elif (abs(et[-1][0])>0.40):        
                output_u = 0.40
            elif (abs(et[-1][0])>0.20): 
                output_u = 0.12
            elif (abs(et[-1][0])>0.01):
                output_u = 0.10
                    
            ## Rule 2. 
            elif et[-1][0] * et[-1][2] > 0 or et[-1][2] == 0:
                if abs(et[-1][0]) >= 0.05:
                    output_u = u[-1] + 2*self._Kp*et[-1][2]
                else:
                    output_u = u[-1] + 0.4*self._Kp*et[-1][2]
            
            ## Rule 3.
            elif et[-1][0] * et[-1][2] < 0 and et[-1][2] * et[-2][2] > 0 or et[-1][0] == 0:
                output_u = self._Kp*et[-1][0] + self._Ki*et[-1][1] + self._Kd*et[-1][2]
                
            ## Rule 4.
            elif et[-1][0] * et[-1][2] < 0 and et[-1][2] * et[-2][2] < 0:
                if abs(et[-1][0] >= 0.05):
                    output_u = u[-1] + 2*self._Kp*et[-1][0]
                else:
                    output_u = u[-1] + 0.6*self._Kp*et[-1][0]
                    
            ## Rule 5.
            elif abs(et[-1][0] <= 0.001):
                output_u = 0.5*et[-1][0] + 0.010*et[-1][1]
                
            else:
                output_u = self._Kp*et[-1][0] + self._Ki*et[-1][1] + self._Kd*et[-1][2]
            
            u[-1] = 10 if u[-1] >= 10 else u[-1]
            u[-1] = -10 if u[-1] <= -10 else u[-1]
            
        else:
            ## Tradition PID Controller
            # u(k)=kp*x(1)+kd*x(2)+ki*x(3); %PID Controller
            output_u = self._Kp*et[-1][0] + self._Ki*et[-1][1] + self._Kd*et[-1][2]
            
        return output_u




def main():
    # print('Test finished.')
    kp = 0.6
    kd = 0.01
    ki = 0.03
    ts = 0.001
    
    print('YES')
    
    sys = ctl.tf([523500], [1, 87.35, 10470, 0])
    dsys = ctl.c2d(sys, ts, 'zoh')
    [num, den] = ctl.tfdata(dsys)
    
    pid = PID(kp, kd, ki, ts)
    
    y = [0,0,0]
    u = [0,0,0]
    
    times = [0,0,0]
    
    et = [[0,0,0], [0,0,0], [0,0,0]]
    
    st_point = 1
    
    for i in range(500):
        
        u_new = pid.process(i, st_point, et, y, u, True)
        
        y_new = -den[0][0][1]*y[-1]-den[0][0][2]*y[-2]-den[0][0][3]*y[-3]+num[0][0][0]*u_new+num[0][0][1]*u[-1]+num[0][0][2]*u[-2]+num[0][0][3]*u[-3]
        
        error = st_point - y_new
        
        tmp_errs = [error, et[-1][1]+error*ts, (error-et[-1][2])/ts]
        
        et.append(tmp_errs)
        u.append(u_new)
        y.append(y_new)
        times.append(i*ts)
    
    plt.figure(1)
    plt.plot(time,y,'r')
    plt.xlabel('time(s)');plt.ylabel('y')
    plt.show()
    
    print('wtf')
    # plt.figure(2)
    # plt.plot(time,ry,'r')
    # plt.xlabel('time(s)');plt.ylabel('error')
    
    
if __name__ == '__name__':
    main()