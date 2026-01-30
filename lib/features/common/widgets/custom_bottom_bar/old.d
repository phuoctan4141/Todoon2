Widget _buildMainActionButton() {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _mainActionController,
        curve: const Interval(0.0, 3.0, curve: Curves.fastOutSlowIn),
      ),
      builder: (context, _) {
        // Đổi icon khi animation đạt 50%
        final shouldShowClose = _mainActionController.value > 0.5;

        return AnimatedSwitcher(
          duration: Durations.medium3,
          transitionBuilder: (child, animation) {
            final rotateTween = shouldShowClose
                ? Tween<double>(begin: 0.0, end: 1.0)
                : Tween<double>(begin: 1.0, end: 0.0);
        
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeIn,
              ),
              child: ScaleTransition(
                scale: animation,
                child: RotationTransition(
                  turns: rotateTween.animate(animation),
                  child: child,
                ),
              ),
            );
          },
          child: FloatingActionButton(
            key: const ValueKey('main'),
            heroTag: null,
            onPressed: _toggleMenu,
            elevation: 6.0,
            backgroundColor: Color.lerp(
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary,
              _mainActionController.value,
            ),
            child: Icon(
              shouldShowClose ? Icons.close_rounded : Icons.add_rounded,
              key: ValueKey(shouldShowClose),
              color: Color.lerp(
                Theme.of(context).colorScheme.onPrimary,
                Theme.of(context).colorScheme.onTertiary,
                _mainActionController.value,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainActionButton() {
    return AnimatedBuilder(
      animation: _mainActionController,
      builder: (context, _) {
        final shouldShowClose = _mainActionController.value > 0.1;

        return Center(
          child: AnimatedSwitcher(
            duration: Durations.medium3,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: shouldShowClose
                ? FloatingActionButton.small(
                    key: const ValueKey('small'),
                    heroTag: null,
                    onPressed: _toggleMenu,
                    elevation: 6.0,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  )
                : FloatingActionButton(
                    key: const ValueKey('big'),
                    heroTag: null,
                    onPressed: _toggleMenu,
                    elevation: 6.0,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.add_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
          ),
        );
      },
    );
  }

  
    FloatingActionButton(
      key: const ValueKey('single'),
      heroTag: null,
      elevation: 6,
      backgroundColor:
          item.color?.withValues(alpha: 0.30) ??
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.30),
      onPressed: item.onTap,
      child: Icon(
        item.icon,
        color: item.color ?? Theme.of(context).colorScheme.onPrimary,
      ),
    );