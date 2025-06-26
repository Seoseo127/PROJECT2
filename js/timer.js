const timers = {};
const intervals = {};

function formatTime(seconds) {
  const hrs = String(Math.floor(seconds / 3600)).padStart(2, '0');
  const mins = String(Math.floor((seconds % 3600) / 60)).padStart(2, '0');
  const secs = String(seconds % 60).padStart(2, '0');
  return `${hrs}:${mins}:${secs}`;
}

function startTimer(subject) {
  if (!timers[subject]) timers[subject] = 0;
  if (intervals[subject]) return;

  intervals[subject] = setInterval(() => {
    timers[subject]++;
    document.getElementById(`display-${subject}`).innerText = formatTime(timers[subject]);
  }, 1000);
}

function pauseTimer(subject) {
  clearInterval(intervals[subject]);
  intervals[subject] = null;
}

function stopTimer(subject, todoId) {
  pauseTimer(subject);
  const totalSeconds = timers[subject] || 0;
  const goalMinutes = parseInt(document.getElementById(`goal-${subject}`).value) || 0;

  $.ajax({
    url: 'save_timer.jsp',
    method: 'POST',
    data: {
      subject: subject,
      totalSeconds: totalSeconds,
      goalMinutes: goalMinutes,
      todoId: todoId
    },
    success: function(response) {
      alert('시간 저장 완료!');
      timers[subject] = 0;
      document.getElementById(`display-${subject}`).innerText = '00:00:00';
    },
    error: function() {
      alert('시간 저장 실패!');
    }
  });
}

function saveGoal(subject) {
  const goal = parseInt(document.getElementById(`goal-${subject}`).value);
  if (isNaN(goal) || goal <= 0) {
    alert('목표 시간을 올바르게 입력하세요.');
    return;
  }
  alert(`목표 시간 ${goal}분 저장됨`);
}