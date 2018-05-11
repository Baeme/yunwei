

class Person(object):
    info_showa = "hello world"
    def __init__(self, name, job):
        self.name = name
        self.job = job

    def Info(self):
        return (self.name, self.job)


rec1 = Person('sjie', 'PythonDeveloper')
rec2 = Person('xiaowen', 'info_show')
print(rec1.info_showa)
print(rec2.Info())
