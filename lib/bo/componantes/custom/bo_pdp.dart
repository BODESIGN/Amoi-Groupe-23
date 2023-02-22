import 'package:flutter/material.dart';

Widget pdp(String uri, Function clickOnpdp,
    [double iconSize = 20, String src = 'NETWORK']) {
  return uri != ''
      ? src == 'NETWORK'
          ? ClipRRect(
            borderRadius: BorderRadius.circular(300),
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: (() {
                clickOnpdp();
              }),
              child: Image.network(uri, fit: BoxFit.cover, scale: 1.0,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                    child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null));
              }),
            ),
          )
          : Image.asset(uri, fit: BoxFit.cover, scale: 1.0)
      : Container(
          color: Colors.white,
          child: InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: (() {
                clickOnpdp();
              }),
              child: Icon(Icons.person, color: Colors.black, size: iconSize)),
        );
}
