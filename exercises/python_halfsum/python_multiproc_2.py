from multiprocessing import Process,Manager

def func1(id,results):
    j=0
    print('func1: starting (from 1 to 100000000)')
    for i in range(1,100000001):
        j=j+i/2
    print('func1: finishing')
    results[id]=j

def func2(id,results):
    j=0
    print('func2: starting (from 100000001 to 200000000)')
    for i in range(100000001,200000001):
        j=j+i/2
    print('func2: finishing')
    results[id]=j

def func3(id,results):
    j=0
    print('func3: starting (from 200000001 to 300000000)')
    for i in range(200000001,300000001):
        j=j+i/2
    print('func3: finishing')
    results[id]=j

def runInParallel(*fns):
    proc=[]
    for i,fn in enumerate(fns):
        p = Process(target=fn,args=(i,results))
        p.start()
        proc.append(p)
    for p in proc:
        p.join()
    print(results)
    print(sum(results.values()))                    
    

if __name__ == '__main__':
    results=Manager().dict()
    runInParallel (func1,func2,func3)



    
