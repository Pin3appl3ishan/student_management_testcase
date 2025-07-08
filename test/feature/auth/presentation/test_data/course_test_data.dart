import 'package:student_management/features/course/domain/entity/course_entity.dart';

class CourseTestData {
  CourseTestData._();

  static List<CourseEntity> getCourseTestData() {
    List<CourseEntity> lstCourses = [
      CourseEntity(courseId: '20fjjdaajdijklf', courseName: 'Python'),
      CourseEntity(courseId: '378dhf-fh89df-jfh45', courseName: 'Java'),
      CourseEntity(courseId: 'rt5vg7-fh89df-jfh45', courseName: 'C++'),
    ];
    return lstCourses;
  }
}