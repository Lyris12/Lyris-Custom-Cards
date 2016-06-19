--次元盾
function c101010254.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c101010254.condition)
	e1:SetCost(c101010254.cost)
	e1:SetOperation(c101010254.activate)
	c:RegisterEffect(e1)
end
function c101010254.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsPlayerCanDiscardDeck(tp,1) 
end
function c101010254.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local t={}
	local l=1
	local dam=math.floor(Duel.GetBattleDamage(tp)/100)
	while Duel.IsPlayerCanDraw(tp,l) do
		t[l]=l
		l=l+1
		if l>dam then break end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010254,0))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	local g=Duel.GetDecktopGroup(tp,announce)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local fg=g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	if announce>fg then announce=fg end
	e:SetLabel(announce)
	e:GetHandler():SetHint(CHINT_NUMBER,e:GetLabel())
end
function c101010254.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetBattleDamage(tp)>=e:GetLabel()*100 then
		Duel.ChangeBattleDamage(tp,Duel.GetBattleDamage(tp)-e:GetLabel()*100)
		else
		Duel.ChangeBattleDamage(tp,0)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(e:GetLabel()*100)
	e1:SetValue(c101010254.op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101010254.op(e,re,dam,r,rp,rc)
	if dam>=e:GetLabel() then
		return dam-e:GetLabel()
	else return 0 end
end
