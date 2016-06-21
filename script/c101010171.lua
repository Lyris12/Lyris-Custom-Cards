--
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(e,c) return c:IsSetCard(0x167) end)
	e2:SetValue(aux.tgoval)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e2)
	--choice 1: draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1108)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,id)
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetTurnPlayer()~=tp end)
	e5:SetTarget(ref.tg1)
	e5:SetOperation(ref.op1)
	c:RegisterEffect(e5)
	--choice 2: gain LP
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(1123)
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,id)
	e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetTurnPlayer()~=tp end)
	e6:SetTarget(ref.tg)
	e6:SetOperation(ref.op)
	c:RegisterEffect(e6)
end
function ref.filter(c)
	return c:IsSetCard(0x167) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function ref.dfilter(c,tid)
	return bit.band(c:GetReason(),0x41)==0x41 and c:GetTurnID()==tid
end
function ref.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(ref.dfilter,tp,0xff,0xff,nil,Duel.GetTurnCount())
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function ref.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(ref.dfilter,tp,0xff,0xff,nil,Duel.GetTurnCount())
	Duel.Draw(tp,ct,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(ref.dfilter,tp,0xff,0xff,nil,Duel.GetTurnCount())
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*300)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(ref.dfilter,tp,0xff,0xff,nil,Duel.GetTurnCount())
	Duel.Recover(tp,ct*300,REASON_EFFECT)
end
