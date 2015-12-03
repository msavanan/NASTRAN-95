      SUBROUTINE ALG14 (XDATA,YDATA,NDATA,XIN,YOUT,YPRIME,NXY,NWOT)
C
C     THIS SPLINE ROUTINE DETERMINES Y AND/OR YPRIME  LINEAR EXTRAPOLATI
C     XDATA AND XIN MUST BE IN ASCENDING ORDER  E1 AND E2 ARE D2YDX2 LAS
C     D2YDX2 LAST-BUT-ONE AT ENDS OF SPECIFIED REGION OF BEAM
C
      REAL M
C
      DIMENSION A(65), B(65), D(65), M(65), XDATA(2), YDATA(2), XIN(1),
     1YOUT(1), YPRIME(1)
C
      IF (NDATA-2) 240,10,70
10    IF (NWOT-1) 20,40,20
20    DO 30 I=1,NXY
30    YOUT(I)=((YDATA(2)-YDATA(1))/(XDATA(2)-XDATA(1)))*(XIN(I)-XDATA(1)
     1)+YDATA(1)
40    IF (NWOT) 240,240,50
50    DO 60 I=1,NXY
60    YPRIME(I)=(YDATA(2)-YDATA(1))/(XDATA(2)-XDATA(1))
      GO TO 240
70    CONTINUE
      E1=1.0
      E2=1.0
      A(1)=1.0
      B(1)=-E1
      D(1)=0.0
      N=NDATA-1
      DO 80 I=2,N
      A(I)=(XDATA(I+1)-XDATA(I-1))/3.0-(XDATA(I)-XDATA(I-1))*B(I-1)/(6.0
     1*A(I-1))
      B(I)=(XDATA(I+1)-XDATA(I))/6.0
80    D(I)=(YDATA(I+1)-YDATA(I))/(XDATA(I+1)-XDATA(I))-(YDATA(I)-YDATA(I
     1-1))/(XDATA(I)-XDATA(I-1))-(XDATA(I)-XDATA(I-1))*D(I-1)/6.0/A(I-1)
      A(NDATA)=-E2
      B(NDATA)=1.0
      D(NDATA)=0.0
      M(NDATA)=A(NDATA)*D(N)/(A(NDATA)*B(N)-A(N)*B(NDATA))
      DO 90 II=2,NDATA
      I=NDATA+1-II
90    M(I)=(D(I)-B(I)*M(I+1))/A(I)
      J=1
      I=1
100   IF (XIN(I)-XDATA(1)) 190,190,110
110   IF (XIN(I)-XDATA(J+1)) 140,140,120
120   IF (J+1-NDATA) 130,140,140
130   J=J+1
      GO TO 110
140   IF (XIN(I)-XDATA(NDATA)) 150,220,220
150   DX=XDATA(J+1)-XDATA(J)
      IF (NWOT-1) 160,170,160
160   YOUT(I)=M(J)/(6.0*DX)*(XDATA(J+1)-XIN(I))**3+M(J+1)/(6.0*DX)*(XIN(
     1I)-XDATA(J))**3+(XDATA(J+1)-XIN(I))*(YDATA(J)/DX-M(J)/6.0*DX)+(XIN
     2(I)-XDATA(J))*(YDATA(J+1)/DX-M(J+1)/6.0*DX)
      IF (NWOT) 170,180,170
170   YPRIME(I)=(-M(J)*(XDATA(J+1)-XIN(I))**2/2.0+M(J+1)*(XIN(I)-XDATA(J
     1))**2/2.0+YDATA(J+1)-YDATA(J))/DX-(M(J+1)-M(J))/6.0*DX
180   I=I+1
      IF (I-NXY) 100,100,240
190   YDASH=(YDATA(2)-YDATA(1))/(XDATA(2)-XDATA(1))-(M(1)/3.0+M(2)/6.0)*
     1(XDATA(2)-XDATA(1))
      IF (NWOT-1) 200,210,200
200   YOUT(I)=YDATA(1)-YDASH*(XDATA(1)-XIN(I))
      IF (NWOT) 210,180,210
210   YPRIME(I)=YDASH
      GO TO 180
220   YDASH=(YDATA(NDATA)-YDATA(N))/(XDATA(NDATA)-XDATA(N))+(M(NDATA)/3.
     10+M(N)/6.0)*(XDATA(NDATA)-XDATA(N))
      IF (NWOT-1) 230,210,230
230   YOUT(I)=YDATA(NDATA)+YDASH*(XIN(I)-XDATA(NDATA))
      IF (NWOT) 210,180,210
240   RETURN
      END