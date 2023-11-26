import 'package:cay_khe/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    // return a 404 beautiful page with center
    return Center(
        child: Container(
          constraints: const BoxConstraints(minHeight: 500),
          margin: const EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/sys/404.svg',
                width: 300,
                height: 300,
              ),
              const Text(
                'Chúng tôi không thể tìm thấy trang bạn yêu cầu',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: TextButton(
                    child: const Text('Quay về trang chủ', style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      appRouter.go('/');
                    }
                ),
              ),
            ],
          ),
        )
    );
  }
}