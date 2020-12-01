class Exemple3 (object):
    """docstring for ClassName"""   
    def __init__ (self, long=45,larg=23):
        self.longueur = long
        self.largeur = larg
        
    def aire (self):
        print ("L'aire de ce rectangle est de ", self.longueur,"X",self.largeur,"=",self.longueur*self.largeur)



class Bin_(object):
    """docstring for ClassName"""
    def __init__(self, arg):

        self.arg = arg

    def _Build(self):
        cript =""
        for i in self.arg:
            code = ord(i)+ 10
            cript += chr(code)
        return cript

    def _UserP(self):
        userp = ""
        for i in self.arg:
            pword = ord(i)- 10
            userp += chr(pword)
        return userp

    def __repr__(self):
        return userp






'''
class Bin_(object):
    """docstring for ClassName"""
    def __init__(self, arg):

        self.arg = arg

    def _Build(self):
        cript =""
        for i in self.arg:
            code = ord(i)+ 10
            cript += chr(code)
        return cript

    def _UserP(self):
        userp = ""
        for i in self.arg:
            pword = ord(i)- 10
            userp += chr(pword)
        return userp
	
	def __repr__(self):
		return userp
"""
class Exemple1(object):
	def __init__(self, arg):
"""		
'''


