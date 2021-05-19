def func1():
    j=0
    print('func: starting (from 1 to 300000000)')
    for i in range(1,300000001):
        j=j+i/2
    print('func1: finishing',j)

if __name__ == '__main__':
    func1()



    
