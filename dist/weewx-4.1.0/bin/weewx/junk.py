class Person(object):
    def __init__(self, name):
        self.name = name

def play(self):
    print("%s is playing!" % self.name)

Person.play = play

p1 = Person("igor")
p1.play()

p2 = Person("joh")
p2.play()