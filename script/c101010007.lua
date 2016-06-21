--PSYStream Sprite
local id,ref=GIR()
function ref.start(c)
--If this card inflicts battle damage to your opponent: You can target up to 2 of your banished "PSYStream" cards; shuffle all targets into the Deck, and if you do, draw 1 card for each card shuffled.
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCountLimit(1,id)
	e0:SetTarget(ref.tdtg)
	e0:SetOperation(ref.tdop)
	c:RegisterEffect(e0)
	--During either player's Main Phase, if this card was banished this turn: You can target 1 Set Spell/Trap Card your opponent controls; it cannot be activated while this card is banished. Spells, Traps, and Spell/Trap effects cannot be activated in response to this effect's activation.
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetLabel(id)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e1:SetCountLimit(1,201010663)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(ref.con)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.operation)
	c:RegisterEffect(e1)
	--This card can attack your opponent directly.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--If this card attacks directly, any battle damage your opponent takes becomes 800 if the amount is more than than 800.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(ref.rdcon)
	e3:SetOperation(ref.rdop)
	c:RegisterEffect(e3)
end
function ref.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget()==nil and ev>800
end
function ref.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,800)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	local ef=e:GetHandler():GetReasonEffect()
	return ef and ef:GetHandler():IsSetCard(0x127) and e:GetHandler():GetFlagEffect(id)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function ref.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,ref.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2)
	end
end
function ref.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function ref.cfilter(c)
	return c:IsSetCard(0x127) and c:IsAbleToDeck()
end
function ref.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and ref.cfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingTarget(ref.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,ref.cfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function ref.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,g=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=g:GetCount() then return end
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(p)
		Duel.Draw(p,1,REASON_EFFECT)
	end
end
