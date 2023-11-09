import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SpiralMatrixGrid(m: 5, n: 5),
    );
  }
}


class SpiralMatrixGrid extends StatelessWidget {
  final int m;
  final int n;

  SpiralMatrixGrid({required this.m, required this.n});

  @override
  Widget build(BuildContext context) {
    List<List<int>> spiralMatrix = generateSpiralMatrix(m, n);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: n,
      ),
      itemCount: m * n,
      itemBuilder: (context, index) {
        int row = index ~/ n;
        int col = index % n;
        return Center(
          child: Text(
            '${spiralMatrix[row][col]}',
            style: TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }

  List<List<int>> generateSpiralMatrix(int m, int n) {
    List<List<int>> matrix = List.generate(m, (row) => List<int>.filled(n, 0));
    debugPrint("Matrix :: ${matrix}");
    int value = 1;
    int top = 0, bottom = m - 1, left = 0, right = n - 1;
//    debugPrint(bottom.toString());
  //  debugPrint(right.toString());
    while (top <= bottom && left <= right) {
      for (int i = left; i <= right; i++) {
        matrix[top][i] = value++;
      //  debugPrint("Forloop Matrix :: ${ matrix[top][i]}");
      }
      top++;
    //  debugPrint( "Top ::"+top.toString());
      for (int i = top; i <= bottom; i++) {
        matrix[i][right] = value++;
        // debugPrint("Forloop Matrix :: ${matrix[i][right]}");
      }
      right--;
      //debugPrint( "Right ::"+right.toString());
      if (top <= bottom) {
        for (int i = right; i >= left; i--) {
          matrix[bottom][i] = value++;
        }
        bottom--;
      }

      if (left <= right) {
        for (int i = bottom; i >= top; i--) {
          matrix[i][left] = value++;
        }
        left++;
      }
    }

    return matrix;
  }
}

class CircularMatrixGrid extends StatelessWidget {
  final int rows = 5;
  final int cols = 5;
  final double radius = 100.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: _buildCircularGrid(),
      ),
    );
  }

  List<Widget> _buildCircularGrid() {
    List<Widget> items = [];

    double angleIncrement = 2 * pi / (rows * cols);
    double currentAngle = 0.0;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        double x = radius * cos(currentAngle);
        double y = radius * sin(currentAngle);

        items.add(
          Positioned(
            left: x + radius,
            top: y + radius,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text(
                '$row-$col',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );

        currentAngle += angleIncrement;
      }
    }

    return items;
  }
}