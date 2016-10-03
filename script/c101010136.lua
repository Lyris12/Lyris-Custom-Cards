--次元盾
function c101010136.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c101010136.condition)
	e1:SetCost(c101010136.cost)
	e1:SetOperation(c101010136.activate)
	c:RegisterEffect(e1)
end
function c101010136.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetMatchingGroupCount(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,nil)>0 and Duel.GetBattleDamage(tp)>=100
end
function c101010136.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=Duel.GetBattleDamage(tp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==1 then
		local announce=1
	else
		local t={}
		local l=1
		while dam>0 and ct>0 do
			dam=dam-100
			ct=ct-1
			t[l]=l
			l=l+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(85087012,2))
		local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	end
	local g=Duel.GetDecktopGroup(tp,announce)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local fg=g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	if announce>fg then announce=fg end
	e:SetLabel(announce)
	e:GetHandler():SetHint(CHINT_NUMBER,e:GetLabel())
end
function c101010136.activate(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetValue(c101010136.op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101010136.op(e,re,dam,r,rp,rc)
	if dam>=e:GetLabel() then
		return dam-e:GetLabel()
	else return 0 end
end
