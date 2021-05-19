from multiprocessing import Process, Manager

def func1(n,j):
    j=0
    print('func1: starting (from 1 to 100000000)')
    for i in range(1,100000001):
        j=j+i/2
    print('func1: finishing',j)
    results[n]=j

def func2(n,j):
    j=0
    print('func2: starting (from 100000001 to 200000000)')
    for i in range(100000001,200000001):
        j=j+i/2
    print('func2: finishing',j)
    results[n]=j

def func3(n,j):
    j=0
    print('func3: starting (from 200000001 to 300000000)')
    for i in range(200000001,300000001):
        j=j+i/2
    print('func3: finishing',j)
    results[n]=j

def runInParallel(*fns):
    proc=[]
    for fn in fns:
        p = Process(target=fn)
        p.start()
        proc.append(p)
    for p in proc:
        p.join()

if __name__ == '__main__':
    results=Manager().dict()
    p1=Process(target=func1,args=(0,results))
    p1.start()
    p2=Process(target=func2,args=(1,results))
    p2.start()
    p3=Process(target=func3,args=(2,results))
    p3.start()
    p1.join()
    p2.join()
    p3.join()
    print (results)
    print (sum(results.values()))
