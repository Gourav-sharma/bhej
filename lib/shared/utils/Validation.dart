class Validation{


  static String validateNumber(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{9,12}$)';
    RegExp regExp = new RegExp(patttern);

    if (value.isEmpty) {
      return 'Mobile number cannot be blank';
    } else if (value.length < 9) {
      return 'Mobile number must be at 10 digits';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return "";
  }


  static String validatePasswordValid(String value) {

    Pattern  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex =  RegExp(pattern.toString());

    if (value.isEmpty) {
      return "Password can't be blank";
    } else  if (!regex.hasMatch(value))
      return 'Not a strong password (Ex. 1234@aA)';
    else
      return "";
  }


  static String validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex =  RegExp(pattern.toString());

    if (value.isEmpty) {
      return "Email can't blank";
    } else  if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return "";

  }



  static  String validateBlank(String value,String ErrorMessage) {
    if (value.trim().isEmpty) {
      return ErrorMessage;
    } else {
      return "";
    }
  }



  static  String validatePincode(String value) {
    if (value.isEmpty) {
      return 'Pincode cannot be blank';
    } else if (value.length < 6) {
      return 'The Pincode must be at least 6 digits';
    }
    return "";
  }




}