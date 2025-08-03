import 'package:flutter/material.dart';

enum PinButtonType { number, delete, biometric, none }

class PinButtonData {
  final PinButtonType type;
  final String? valueNumber;

  const PinButtonData({required this.type, this.valueNumber});
}

class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.onPressed,
    required this.onDelete,
    required this.onBiometric,
    this.showBiometric = false,
  });

  final Function(String value) onPressed;
  final Function() onDelete;
  final Function() onBiometric;
  final bool showBiometric;

  List<List<PinButtonData>> get rows {
    return [
      [
        PinButtonData(type: PinButtonType.number, valueNumber: '1'),
        PinButtonData(type: PinButtonType.number, valueNumber: '2'),
        PinButtonData(type: PinButtonType.number, valueNumber: '3'),
      ],
      [
        PinButtonData(type: PinButtonType.number, valueNumber: '4'),
        PinButtonData(type: PinButtonType.number, valueNumber: '5'),
        PinButtonData(type: PinButtonType.number, valueNumber: '6'),
      ],
      [
        PinButtonData(type: PinButtonType.number, valueNumber: '7'),
        PinButtonData(type: PinButtonType.number, valueNumber: '8'),
        PinButtonData(type: PinButtonType.number, valueNumber: '9'),
      ],
      [
        PinButtonData(type: showBiometric ? PinButtonType.biometric : PinButtonType.none),
        PinButtonData(type: PinButtonType.number, valueNumber: '0'),
        PinButtonData(type: PinButtonType.delete),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rows
          .map(
            (rowWidgets) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: rowWidgets
                    .map(
                      (data) => PinButton(
                        data: data,
                        onPressed: (data) {
                          if (data.type == PinButtonType.delete) {
                            onDelete();
                          } else if (data.type == PinButtonType.biometric) {
                            onBiometric();
                          } else if (data.type == PinButtonType.number) {
                            onPressed(data.valueNumber!);
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }
}

class PinButton extends StatelessWidget {
  const PinButton({
    super.key,
    required this.data,
    required this.onPressed,
  });

  final PinButtonData data;
  final Function(PinButtonData data) onPressed;

  @override
  Widget build(BuildContext context) {
    if (data.type == PinButtonType.none) {
      return const SizedBox(
        height: 70,
        width: 70,
      );
    }
    return GestureDetector(
      onTap: () => onPressed(data),
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
          color: Colors.grey[200],
        ),
        alignment: Alignment.center,
        width: 70,
        height: 70,
        child: data.type == PinButtonType.delete
            ? const Icon(Icons.backspace_outlined, size: 28)
            : data.type == PinButtonType.biometric
            ? const Icon(Icons.fingerprint, size: 28, color: Color(0xFF9447FF))
            : data.type == PinButtonType.number
            ? Text(
                data.valueNumber!,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
