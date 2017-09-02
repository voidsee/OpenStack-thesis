import cherrypy
from reservation.manager.ManagerTools import ManagerTool
from reservation.stack.OSTools import OSTools
from reservation.stack.OSKeystone import OSRole
from reservation.stack.OSKeystone import OSProject
from reservation.stack.OSKeystone import OSGroup
from reservation.service.Group import Group
from reservation.service.Role import Role

import reservation.service.MySQL as MySQL

class ManagerSystem():
    keystoneAuthList = None

    """This class make initial configuration to new OpenStack it 
       should be also made for empty (no data) database

    New OpenStack need to be configured before system can operates.
    This class create roles
    """

    @cherrypy.expose
    @cherrypy.tools.json_out()
    def index(self):
        try:
            if not ManagerTool.isAuthorized(cherrypy.request.cookie, self.keystoneAuthList, require_admin=True):
                data = dict(current="System manager", user_status="not authorized")
            else:
                studRole = None
                labRole = None
                modRole = None
                defProject = None
                groupStud = None
                groupModer = None
                defaults = MySQL.mysqlConn.select_defaults()
                session_id = cherrypy.request.cookie["ReservationService"].value
                osKSAuth = self.keystoneAuthList[session_id]
                session = osKSAuth.createKeyStoneSession()
                osRole = OSRole(session=session)
                osProject = OSProject(session=session)
                osGroup = OSGroup(session=session)

                if len(defaults) > 0:
                    defaults = defaults[0]
                    studRole = osRole.find(id=defaults["role_student"])
                    labRole = osRole.find(id=defaults["role_lab"])
                    modRole = osRole.find(id=defaults["role_moderator"])
                    defProject = osProject.find(id=defaults["project"])
                    groupStud = osGroup.find(id=defaults["group_student"])
                    groupModer = osGroup.find(id=defaults["group_moderator"])
                    groupAdmin = osGroup.find(id=defaults["group_admin"])
                else:
                    studRole = Role().parseObject(osRole.create(name="student"))
                    labRole = Role().parseObject(osRole.create(name="lab"))
                    modRole = Role().parseObject(osRole.create(name="moderator"))
                    defProject = osProject.create(name="reservation_system")
                    groupStud = Group().parseObject(osGroup.create(name="students"))
                    groupModer = Group().parseObject(osGroup.create(name="moderators"))

                    osRole.grantGroup(group_id=groupStud.id,role_id=studRole.id)
                    osRole.grantGroup(group_id=modRole.id, role_id=modRole.id)

                    MySQL.mysqlConn.insert_defaults(project_id=defProject.id,
                                                    role_student=studRole.id,
                                                    role_lab=labRole.id,
                                                    role_moderator=modRole.id,
                                                    group_student=groupStud.id,
                                                    group_moderator=groupModer.id)

                data = dict(current="System manager",
                            default_project=OSTools.prepareJSON(defProject),
                            role_student=studRole.to_dict(),
                            role_lab=labRole.to_dict(),
                            role_moderator=modRole.to_dict(),
                            group_students=groupStud.to_dict(),
                            group_moderator=groupModer.to_dict())
                MySQL.mysqlConn.commit()
        except Exception as e:
            if not len(defaults) > 0:
                if studRole is not None and osRole is not None:
                    osRole.delete(studRole.id)
                if labRole is not None and osRole is not None:
                    osRole.delete(labRole.id)
                if modRole is not None and osRole is not None:
                    osRole.delete(modRole.id)
                if defProject is not None and osProject is not None:
                    osProject.delete(defProject.id)
                if groupStud is not None and osGroup is not None:
                    osGroup.delete(groupStud.id)
                if groupModer is not None and osGroup is not None:
                    osGroup.delete(groupModer.id)
            data = dict(current="System manager", error=str(e))
        finally:
            MySQL.mysqlConn.close()
            return data

    def __createOS(self, name, osObject):

        role = osObject.find(name=name)
        if len(role) > 0 and role is not None:
            return role[0]
        else:
            return osObject.create(name=name)

