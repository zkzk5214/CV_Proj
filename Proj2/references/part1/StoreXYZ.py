with open('points3D.txt', 'r') as f:
    for i in f.readlines():
        n = list(map(float, i.split()))
        s = n[1], n[2], n[3]
        s = (' '.join(map(str, s)))
        print(s)
