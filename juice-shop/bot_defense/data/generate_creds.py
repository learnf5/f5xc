file = open("./credentials.txt", 'w')


for i in range(10000):
    if i % 2 == 0:
        data = ("f5test{}@co.uk : 123password{} \n" .format(i, i))
    else:
        data = ("Volterratest{}@co.uk : 345password{} \n".format(i, i))
    file.write(data)
