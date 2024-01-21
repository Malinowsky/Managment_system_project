import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managment_system_project/features/presentation/widgets/info_gesture_detector.dart';
import 'package:managment_system_project/features/presentation/constants.dart'; // Jeśli masz wspólne stałe
import '../../../../global/common/toast.dart';
import '../../models/course_model.dart';
import '../../models/group_model.dart';
import '../../models/student_model.dart'; // Dostosuj import w zależności od struktury projektu

class StudentCoursesPage extends StatefulWidget {
  const StudentCoursesPage({super.key});

  @override
  State<StudentCoursesPage> createState() => _StudentCoursesPageState();
}

class _StudentCoursesPageState extends State<StudentCoursesPage> {
  String? selectedStudentId;
  String? selectedCourseId;
  String? selectedGroupId;
  List<Student> studentsList = [];
  List<Course> coursesList = [];
  List<ClassGroup> groupsList = [];
  Map<String, List<String>> courseToStudentsMap = {};
  Map<String, String> courseToGroupsMap = {};

  @override
  void initState() {
    super.initState();
    fetchStudents();
    fetchCourses();
    fetchGroups();
    fetchStudentCourseAssignments();
  }

  Future fetchStudents() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('students').get();
    List<Student> fetchedStudents = querySnapshot.docs
        .map((doc) => Student.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    setState(() {
      studentsList = fetchedStudents;
    });
  }

  Future fetchCourses() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('courses').get();
    List<Course> fetchedCourses = querySnapshot.docs
        .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    setState(() {
      coursesList = fetchedCourses;
    });
  }

  Future fetchGroups() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('groups').get();
    List<ClassGroup> fetchedGroups = querySnapshot.docs
        .map((doc) => ClassGroup.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    setState(() {
      groupsList = fetchedGroups;
    });
  }

  Future<void> fetchStudentCourseAssignments() async {
    // Fetch the existing assignments of students to courses.
    // This will be used to filter out already assigned students and groups.
    var studentCoursesCollection =
        FirebaseFirestore.instance.collection('studentCourses');
    var querySnapshot = await studentCoursesCollection.get();
    // Initialize a temporary map to keep the student assignments and group assignments.
    var tempMap = <String, List<String>>{};
    var tempGroupMap = <String, String>{};
    for (var doc in querySnapshot.docs) {
      // Extract courseId and studentId from the document.
      String courseId = doc.data()['courseId'] as String;
      String studentId = doc.data()['studentId'] as String;
      String? groupId = doc.data()['groupId'] as String?;
      // Add the studentId to the list for the courseId.
      tempMap[courseId] = (tempMap[courseId] ?? [])..add(studentId);
      // If groupId is available, add it to the group map for the courseId.
      if (groupId != null) {
        tempGroupMap[courseId] = groupId;
      }
    }

    // Update the state with the new map.
    setState(() {
      courseToStudentsMap = tempMap;
      courseToGroupsMap = tempGroupMap.cast<String, String>();
    });
  }

  List<DropdownMenuItem<String>> getFilteredGroupsItems() {
    // Get IDs of all groups that are already assigned to any course
    var assignedGroupIds =
        coursesList.expand((course) => course.groupStudentIds).toSet();

    // Return all groups that are not assigned
    return groupsList
        .where((group) => !assignedGroupIds.contains(group.id))
        .map<DropdownMenuItem<String>>((ClassGroup group) {
      return DropdownMenuItem<String>(
        value: group.id,
        child: Text(group.name),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> getFilteredStudentItems() {
    // Get IDs of all students that are already assigned to the selected course
    var assignedStudentIds = selectedCourseId != null
        ? (coursesList
            .firstWhere(
              (course) => course.id == selectedCourseId,
              orElse: () => Course(
                id: '',
                name: '',
                description: '',
                credits: 0,
                professorId: '',
                reserveStudentsId: [],
                groupStudentIds: [],
              ),
            )
            .groupStudentIds)
        : [];

    // Return all students that are not assigned
    return studentsList
        .where((student) => !assignedStudentIds.contains(student.id))
        .map<DropdownMenuItem<String>>((Student student) {
      return DropdownMenuItem<String>(
        value: student.id,
        child: Text(student.name + " " + student.surname),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Assign Student to Course"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Select Course
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 9,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedCourseId,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCourseId = newValue;
                          selectedGroupId =
                              null; // Reset the selected group when a new course is selected
                        });
                      },
                      items: coursesList
                          // Filter out courses that already have a group assigned
                          .where((course) =>
                              !courseToGroupsMap.containsKey(course.id))
                          .map<DropdownMenuItem<String>>((Course course) {
                        return DropdownMenuItem<String>(
                          value: course.id,
                          child: Text(course.name),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Select Course',
                      ),
                    ),
                  ),
                  sizedBox,
                  //Select Group
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 9,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      key: ValueKey(selectedGroupId),
                      value: selectedGroupId,
                      onChanged: (newValue) {
                        setState(() {
                          selectedGroupId = newValue;
                        });
                      },
                      items: groupsList.map<DropdownMenuItem<String>>(
                          (ClassGroup classGroup) {
                        return DropdownMenuItem<String>(
                          value: classGroup.id,
                          child: Text(classGroup.name), // Wyświetl nazwę grupy
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Select Group',
                      ),
                    ),
                  ),
                  sizedBox,
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 9,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedStudentId,
                      onChanged: (newValue) {
                        setState(() {
                          selectedStudentId = newValue;
                        });
                      },
                      items: getFilteredStudentItems(),
                      decoration: InputDecoration(
                        labelText: 'Select Student',
                      ),
                    ),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      if (selectedGroupId != null && selectedCourseId != null) {
                        // Assign the selected group to the course
                        assignGroupToCourse(selectedGroupId!, selectedCourseId!);
                      } else if (selectedStudentId != null && selectedCourseId != null) {
                        // Assign the selected student to the course
                        assignStudentToCourse(selectedStudentId!, selectedCourseId!);
                      } else {
                        // Neither a group nor a student has been selected
                        showToast(message: "Please select a group or a student and a course");
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.width / 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Assign",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> assignStudentToCourse(String studentId, String courseId) async {
    // Reference to the course document in Firestore
    DocumentReference courseRef = FirebaseFirestore.instance.collection('courses').doc(courseId);

    // Fetch the current course document
    DocumentSnapshot courseSnapshot = await courseRef.get();

    if (courseSnapshot.exists && courseSnapshot.data() is Map<String, dynamic>) {
      // Get the current data of the course
      Map<String, dynamic> courseData = courseSnapshot.data() as Map<String, dynamic>;

      // Get the current list of reserved student IDs, or initialize as an empty list if not present
      List<String> currentReservedIds = List<String>.from(courseData['reserveStudentsId'] ?? []);

      // Check if the student is not already added to the course
      if (!currentReservedIds.contains(studentId)) {
        // Add the new student ID to the list of reserved student IDs
        currentReservedIds.add(studentId);

        // Update the course document with the new list of reserved student IDs
        await courseRef.update({'reserveStudentsId': currentReservedIds});

        showToast(message: "Student added to the course successfully");
      } else {
        showToast(message: "Student is already assigned to the course");
      }
    } else {
      showToast(message: "Course not found");
    }
  }


  Future<void> assignGroupToCourse(String groupId, String courseId) async {
    // Get the group document by the groupId
    DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .get();

    if (groupSnapshot.exists && groupSnapshot.data() is Map<String, dynamic>) {
      // Extract the studentIds and group name from the group document
      List<dynamic> studentIds =
          (groupSnapshot.data() as Map<String, dynamic>)['studentIds'];
      String groupName = (groupSnapshot.data() as Map<String, dynamic>)['name'];

      // Get the course document by the courseId
      DocumentReference courseRef =
          FirebaseFirestore.instance.collection('courses').doc(courseId);

      // Update the course document with the group's studentIds and name
      await courseRef.update({
        'groupName': groupName,
        // Assuming you want to overwrite the course name with the group name
        'groupStudentIds': studentIds.map((id) => id.toString()).toList()
      });

      showToast(message: "Group assigned to course successfully");
    } else {
      showToast(message: "Group not found or has no students");
    }
  }

  Future<void> assignToCourse(String? groupId, String? studentId, String courseId) async {
    DocumentReference courseRef = FirebaseFirestore.instance.collection('courses').doc(courseId);

    DocumentSnapshot courseSnapshot = await courseRef.get();
    if (!courseSnapshot.exists || !(courseSnapshot.data() is Map<String, dynamic>)) {
      showToast(message: "Course not found");
      return;
    }

    Map<String, dynamic> courseData = courseSnapshot.data() as Map<String, dynamic>;
    List<String> currentStudentIds = List<String>.from(courseData['groupStudentIds'] ?? []);
    List<String> reserveStudentIds = List<String>.from(courseData['reserveStudentsId'] ?? []);

    if (groupId != null) {
      // Assigning a group to the course
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance.collection('groups').doc(groupId).get();
      if (!groupSnapshot.exists || !(groupSnapshot.data() is Map<String, dynamic>)) {
        showToast(message: "Group not found or has no students");
        return;
      }

      List<String> groupStudentIds = List<String>.from((groupSnapshot.data() as Map<String, dynamic>)['studentIds']);
      currentStudentIds.addAll(groupStudentIds.where((id) => !currentStudentIds.contains(id)));
      await courseRef.update({'groupStudentIds': currentStudentIds});
      showToast(message: "Group assigned to course successfully");
    } else if (studentId != null) {
      // Assigning an individual student to the course
      if (!currentStudentIds.contains(studentId) && !reserveStudentIds.contains(studentId)) {
        reserveStudentIds.add(studentId);
        await courseRef.update({'reserveStudentsId': reserveStudentIds});
        showToast(message: "Student added to the course successfully");
      } else {
        showToast(message: "Student is already assigned to the course");
      }
    } else {
      showToast(message: "No group or student selected");
    }
  }

}
