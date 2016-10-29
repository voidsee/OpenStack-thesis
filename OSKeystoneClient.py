from keystoneclient.v3.projects import ProjectManager as KSProjectManager
from keystoneclient.v3 import client as KSClient
import pprint


class OSKeystoneClient:
    session = None
    client = None
    projectManager = None

    def __init__(self, sess):
        self.session = sess
        self.client = KSClient.Client(session=self.session)
        self.projectManager = KSProjectManager(self.client)

    def createProject(self, name, domain):
        return self.projectManager.create(name, domain)

    def listProject(self):
        return self.projectManager.list()

    def deleteProject(self, name):
        return self.projectManager.delete(name, domain)

    def getProject(self, name):
        return self.projectManager.get(name)
