切比雪夫模拟信号生成

------

信号生成：

磁化强度的变化产生电压信号：
$$
V(t)=-\mu_0\frac{d}{dt}\int_{object}\sigma_r(r)\cdot M(r,t)d^3r \qquad \qquad (1)
$$
$$\sigma_r(r)$$为接收线圈灵敏度，$\mu_0$为真空磁导率，$M$为磁化响应。$r$表示位置。

在某一方向上的接收信号，以x向为例:
$$
V(t) = -\mu_0\sigma_x\int_{object}M_x(r,t)d^3r	\qquad \qquad(2)
$$
引入$s(r,t)$表示位置r处产生的信号，假设粒子为$\delta$分布，去除体积积分。粒子磁化强度$M$由局部场$H(r,t)$确定，x向的接收信号可以写成：
$$
s(r,t)=-\frac{d}{dt}M(r,t)=-\frac{d}{dt}M(H(r,t))=-\frac{\partial M}{\partial H}\frac{dH(r,t)}{dt}=-M'(H)\frac{dH(r,t)}{dt} \qquad \qquad (3)
$$

------

下面为粒子磁化模型的建立：

langevin模型的粒子磁化:
$$
M(\xi)=M_0(coth\xi-1/\xi) \qquad \qquad (4)
$$
$M_0$为饱和磁化:
$$
\xi=\frac{\mu_0mH}{k_BT} \qquad \qquad (5)
$$
$m$为磁矩，$H$ 为外场强

------

接下来是信号编码：

磁场变化:
$$
H(x,t) = H_s(x)-H_D(t) \qquad \qquad (6)
$$
$H_s(x)$为选择场，$H_D(t)$为驱动场。

假设驱动场周期变化，频率$w_o=2\pi/T$,导致随时间变化的磁化，接收的粒子信号可以使用傅里叶级数表示为:
$$
s(t) = \sum_{n=-\infin}^{\infin}S_ne^{inw_0t}\qquad \qquad (7)
$$
对应的系数表示为（可参考傅里叶级数推导公式），并将s(t)用公式（3）替换:
$$
S_N=\frac{1}{T}\int_{-T/2}^{T/2}s(t)e^{-inw_0t}dt=-\frac{1}{T}\int_{-T/2}^{T/2}M'(H)\frac{dH}{dt}e^{-inw_0t}dt\qquad \qquad(8)
$$
用$H_D(t)$的反函数消去时间变量:
$$
t = t(H_D) \qquad \qquad (9)
$$
联合公式（8）和（9）得:
$$
S_N=-\frac{1}{T}\int_{H_D(-T/2)}^{H_D(T/2)}M'(H_s-H_D)e^{-inw_0t(H_D)}dH_D \qquad \qquad (9)
$$
根据公式(6)，假设驱动场幅值为A，频率为$w_0$:
$$
H(x,t)=H_S(x)-H_D(t)=H_S(x)-Acosw_0t\qquad\qquad(10)
$$
因此，$t(H_D)$可以进一步被表示为:
$$
t(H_D) = \overline{+}\frac{1}{w_0}arccos\frac{H_D}{A} \qquad \qquad (11)
$$
带入公式(9)可得：
$$
\begin{aligned}
S_n&=\frac{1}{T}\{\int_{-A}^{A}M'(H_S-H_D)e^{in arccos(H_D/A)}dH_D + \int_{A}^{-A}M'(H_S-H_D)e^{-inarccos(H_D/A)}dH_D\}\\
&=\frac{1}{T}\{\int_{-A}^{A}M'(H_S-H_D)(e^{in arccos(H_D/A)}-e^{-inarccos(H_D/A)})dH_D \}\\
&=\frac{2i}{T}\{\int_{-A}^{A}M'(H_S-H_D)sin(n arccos(H_D/A))dH_D \} \qquad \qquad (12)
\end{aligned}
$$
这里sin（n*arccos）可以用切比雪夫多项式近似:
$$
U_n(x)=\frac{sin((n+1)arccosx)}{sin(arccosx)} \qquad \qquad (13)
$$
根据公式(13)，公式（12）可以写为:（已知$sin(arccosx)=\sqrt{1-x^2}$):
$$
S_n =\frac{2i}{T}\{\int_{-A}^{A}M'(H_S-H_D)U_{n-1}(H_D/A)\sqrt{1-(H_D/A)^2}dH_D \}  \qquad \qquad (14)
$$
定义：
$$
U_{n-1}(x)\sqrt{1-x^2}=sin(narccos(x))=0 \quad for \quad |x|>1 \qquad \qquad (15)
$$
（14）可以表示为卷积形式：
$$
S_n =\frac{2i}{T}M'(H_S)*U_{n-1}(H_S/A)\sqrt{1-(H_S/A)^2}  \qquad \qquad (16)
$$
