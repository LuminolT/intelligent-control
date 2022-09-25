import control as ctl
import matplotlib as plt
import time

class expPID():
    
    def __init__(self, kp: float, ki: float, kd: float, ts: float) -> None:
        
        self._Kp = kp
        self._Ki = ki
        self._Kd = kd
        self._Ts = ts   ## 采样间隔
        self.inte_error = 0    # 直到上一次的误差值
        self.pre_error = 0     # 上一次的误差值
        self.time = []
        self.r = []
        self.u = []
        self.y = []
        self.error = []
        self.ry = []
        
        self.u_1 = 0
        self.u_2 = 0
        self.u_3 = 0
        self.y_1 = 0
        self.y_2 = 0
        self.y_3 = 0
        
        self.x = [0, 0, 0]
        ## e(k) delta e(k) ∫e(k)
        
        self.x2_1 = 0
        
        self.error_1 = 0
        
        ## Maintain the Integration process
    
    @property
    def y(self):
        return self.y
    
    @property
    def u(self):
        return self.u
        
    def process(self, t: float, set_point: float, u_t: float, num, den):
    
        self.time.append(t * self._Ts)
        
        self.r.append(1.0)                    #Tself.racing Step Signal
        self.u.append(self._Kp*self.x[0]+self._Kd*self.x[1]+self._Ki*self.x[2]) #PID Contself.rolleself.r

        # Rule 1
        if (abs(self.x[0])>0.8):
            self.u[t]=0.45
        elif (abs(self.x[0])>0.40):
            self.u[t]=0.40
        elif (abs(self.x[0])>0.20):
            self.u[t]=0.12 
        elif (abs(self.x[0])>0.01):
            self.u[t]=0.10   
    
        ## Rule 2
        if (self.x[0]*self.x[1]>0 or (self.x[1]==0)):
            if (abs(self.x[0])>=0.05):
                self.u[t]=self.u_1+2*self._Kp*self.x[0]
            else:
                self.u[t]=self.u_1+0.4*self._Kp*self.x[0]

        ## Rule 3
        if ((self.x[0]*self.x[1]<0 and self.x[1]*self.x2_1>0) or (self.x[0]==0)):
            self.u[t]=self.u[t]
    
        if (self.x[0]*self.x[1]<0 and self.x[1]*self.x2_1<0):   #self.rself.ule4
            if (abs(self.x[0])>=0.05):
                self.u[t]=self.u_1+2*self._Kp*self.error_1
            else:
                self.u[t]=self.u_1+0.6*self._Kp*self.error_1
    
        ## self.rself.ule5:Integself.ration sepaself.ration PI contself.rol
        if (abs(self.x[0])<=0.001):   
            self.u[t]=0.5*self.x[0]+0.010*self.x[2]
            
        #self.restself.ricting the oself.utpself.ut of contself.rolleself.r
        if (self.u[t]>=10):
            self.u[t]=10
        if (self.u[t]<=-10):
            self.u[t]=-10
    
        #Lineaself.r model
        self.y.append(-den[0][0][1]*self.y_1-den[0][0][2]*self.y_2-den[0][0][3]*self.y_3+num[0][0][0]*self.u_1+num[0][0][1]*self.u_2+num[0][0][2]*self.u_3)
        
        self.error.append(self.r[t] - self.y[t])
        
        return self.y[-1]



def main():
    # print('Test finished.')
    kp = 0.6
    kd = 0.01
    ki = 0.03
    ts = 0.001
    
    sys = ctl.tf([523500], [1, 87.35, 10470, 0])
    dsys = ctl.c2d(sys, ts, 'zoh')
    [num, den] = ctl.tfdata(dsys)
    
    pid = expPID(kp, kd, ki, ts)
    
    for i in range(500):
        output = expPID.process(i, 1, output, num, den)
        
    plt.figure(1)
    plt.plot(time,r,'b',time,y,'r')
    plt.xlabel('time(s)');plt.ylabel('r,y')
    plt.figure(2)
    plt.plot(time,ry,'r')
    plt.xlabel('time(s)');plt.ylabel('error')
    
    
if __name__ == '__name__':
    main()