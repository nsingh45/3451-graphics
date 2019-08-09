import java.util.*;

GTMatrixStack stackInstance;
float[][] identity;

//Matrix class: wrapper for 2d array of floats
class Matrix {
  
  float[][] arr;
  
  //constructor
  Matrix(float[][] arr) {
    this.arr = arr;
  }
  
  //constructor to make for easy copying from another matrix
  Matrix(Matrix copied) {
    this.arr = copied.getArray(); 
  }
  
  //returns the backing array of floats (easy deep copy)
  float[][] getArray() {
    return this.arr;
  }
  
  //changes the backing array of floats
  void setArray(float[][] changed) {
     this.arr = changed;
  }
  
  //for debugging - same as print_ctm
  String toString() {
    String output = "";
    for (int i = 0; i < this.arr.length; i++) {
      output += "[";
        for (int j = 0; j < this.arr[i].length; j++) {
         output += this.arr[i][j] + ", ";
        }
      output = output.substring(0, output.length() - 2); //cuts off the unnecessary comma
      output += "]\n"; //adds that last bracket and goes to a new line
    }
    return output;
  }
}

//Matrix stack lives here; backing data structure is a Stack of Matrices
class GTMatrixStack {
  
  //backing stack and reference to top of stack
  public Stack<Matrix> matrixStack;
  Matrix top;
  
  //Constructor: makes a new identity matrix and stack
  //Pushes the identity matrix and sets the top reference to this
  GTMatrixStack() {
    float[][] id = newIdentityMatrix();
    this.matrixStack = new Stack<Matrix>();
    Matrix initial = new Matrix(id);
    matrixStack.push(initial);
    this.top = initial;
  }
  
  //returns a reference to the top of the stack (should be the CTM)
  Matrix getCTM() {
    return this.top;
  }
  
  //as the backing matrixStack is inaccessible to outside methods
  // we must specify push and pop behavior for the instance of 
  // GTMatrixStack - performs a push on the backing Stack data structure
  // and re-sets the top reference
  void push(Matrix next) {
    matrixStack.push(next);
    this.top = next;
  }
  
  //return whether the backing matrixStack is empty
  boolean isEmpty() {
    return matrixStack.empty();
  }
  
  // pops the top of the backing matrixStack if it isn't empty
  // re-sets the top reference
  void pop() {
    matrixStack.pop();
    if (!this.isEmpty()) {
      this.top = matrixStack.peek();
    } else {
      this.top = null;
    }
  }
  
  //makes sure the top item on the matrixStack actually contains
  // the correct value - takes a deep copy of the top reference 
  // and sets the value of the top item on the stack
  void changeCTM() {
    matrixStack.peek().setArray(top.getArray()); 
  }
}

//creates an instance of the GTMatrixStack class with associated methods
void gtInitialize()
{
  stackInstance = new GTMatrixStack();
}

//copies the CTM (from the top-of-stack reference)
// pushes the copy to the stack
// makes sure that copy is a deep copy
void gtPushMatrix()
{
  Matrix copy = new Matrix(stackInstance.getCTM());
  stackInstance.push(copy);
  stackInstance.changeCTM();
}

//if there is more than 1 item on the stack
// (analagous to the identity matrix)
// pop the item and make sure references/copies are updated
void gtPopMatrix()
{
  if (stackInstance.matrixStack.size() == 1) {
    System.out.println("Empty stack");
  } else {
     stackInstance.pop();
     stackInstance.changeCTM();
  }
}

//create a new translation matrix using passed-in values
// get a reference to the top of the stack
// multiply the CTM reference by the translation matrix IN THE CORRECT ORDER
// make sure copies/references are updated
void gtTranslate(float x, float y, float z) //<>//
{
  
  float[][] modified = newIdentityMatrix();
  modified[0][3] = x;
  modified[1][3] = y;
  modified[2][3] = z;
  Matrix translationMatrix = new Matrix(modified);
  
  Matrix ctm = stackInstance.getCTM();
  stackInstance.top = multiply(ctm, translationMatrix);
  stackInstance.changeCTM();
}

//create a scaling matrix using passed-in values
// get a reference to the top of the stack
// multiply the CTM reference by the scaling matrix IN THE CORRECT ORDER
// update references/values
void gtScale(float x, float y, float z)
{
  float[][] modified = newIdentityMatrix();
  modified[0][0] = x;
  modified[1][1] = y;
  modified[2][2] = z;
  Matrix scalingMatrix = new Matrix(modified);
  
  Matrix ctm = stackInstance.getCTM();
  stackInstance.top = multiply(ctm, scalingMatrix);
  stackInstance.changeCTM();
}

//create a rotation matrix using passed-in values (rotating around x-axis)
// convert degrees to radians
// get a reference to the top of the stack
// multiply the CTM reference by the rotation matrix IN THE CORRECT ORDER
// update references/values
void gtRotateX(float theta)
{
  theta = radians(theta);
  float[][] modified = newIdentityMatrix();
  modified[1][1] = cos(theta);
  modified[2][2] = cos(theta);
  modified[2][1] = sin(theta);
  modified[1][2] = -sin(theta);
  Matrix rotateMatrix = new Matrix(modified);
  
  Matrix ctm = stackInstance.getCTM();
  stackInstance.top = multiply(ctm, rotateMatrix);
  stackInstance.changeCTM();
}

//create a rotation matrix using passed-in values (rotating around y-axis)
// convert degrees to radians
// get a reference to the top of the stack
// multiply the CTM reference by the rotation matrix IN THE CORRECT ORDER
// update references/values
void gtRotateY(float theta)
{
  theta = radians(theta);
  float[][] modified = newIdentityMatrix();
  modified[0][0] = cos(theta);
  modified[2][2] = cos(theta);
  modified[0][2] = sin(theta);
  modified[2][0] = -sin(theta);
  Matrix rotateMatrix = new Matrix(modified);
  
  Matrix ctm = stackInstance.getCTM();
  stackInstance.top = multiply(ctm, rotateMatrix);
  stackInstance.changeCTM();
}

//create a rotation matrix using passed-in values (rotating around z-axis)
// convert degrees to radians
// get a reference to the top of the stack
// multiply the CTM reference by the rotation matrix IN THE CORRECT ORDER
// update references/values
void gtRotateZ(float theta)
{
  theta = radians(theta);
  float[][] modified = newIdentityMatrix();
  modified[1][1] = cos(theta);
  modified[0][0] = cos(theta);
  modified[0][1] = -sin(theta);
  modified[1][0] = sin(theta);
  Matrix rotateMatrix = new Matrix(modified);
  
  Matrix ctm = stackInstance.getCTM();
  stackInstance.top = multiply(ctm, rotateMatrix);
  stackInstance.changeCTM();
}

//grabs a reference to the CTM and gets its backing array
//iterates through the array and prints each item with nice spacing/brackets
void print_ctm()
{
  Matrix transform = stackInstance.getCTM();
  float[][] ctm = transform.getArray();
  
  String output = "";
  
  for (int i = 0; i < ctm.length; i++) {
    output += "[";
    for (int j = 0; j < ctm[i].length; j++) {
       output += ctm[i][j] + ", ";
    }
    output = output.substring(0, output.length() - 2); //cuts off the unnecessary comma
    output += "]\n"; //adds that last bracket and goes to a new line
  }
  System.out.println(output);
}


//2 matrices enter, 1 matrix leaves
// create a result matrix and populate with 0's
// go through rows/columns of 2 operands and add values to result accordingly
// return new matrix with result of multiplication
Matrix multiply(Matrix a, Matrix b) {
  float[][] first = a.getArray();
  float[][] second = b.getArray();
  float[][] result = new float[4][4];
  for (int i = 0; i < 4; i++) {
   for (int j = 0; j < 4; j++) {
     result[i][j] = 0.0; 
   }
  }
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      for (int k = 0; k < 4; k++) {
         result[i][j] += first[i][k] * second[k][j];
      }
    }
  }
  return new Matrix(result);
}

//creates a float array corresponding to a new identity matrix
float[][] newIdentityMatrix() {
   float[][] id = new float[4][4];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        id[i][j] = 0.0; 
      }
    }
    id[0][0] = 1.0;
    id[1][1] = 1.0;
    id[2][2] = 1.0;
    id[3][3] = 1.0;
  return id;
}