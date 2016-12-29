--created & coded by Lyris
--制勝竜⛎
function c101010369.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c101010369.sprcon)
	e0:SetOperation(c101010369.sprop)
	e0:SetValue(0x7327)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,se,ep,st) return bit.band(st,0x7327)==0x7327 end)
	e1:SetTarget(c101010369.target)
	e1:SetOperation(c101010369.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101010369.con)
	e2:SetCost(c101010369.cost)
	e2:SetTarget(c101010369.tg)
	e2:SetOperation(c101010369.op)
	c:RegisterEffect(e2)
	if not relay_check then
		relay_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010369.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010369.relay=true
c101010369.point=1
function c101010369.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,481)
	Duel.CreateToken(1-tp,481)
end
function c101010369.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	local m=c:GetMaterial():IsExists(Card.IsCode,1,nil,101010378)
	if chk==0 then return c:GetFlagEffect(10001100)>=1 or m end
	if m then return end
	if point==1 then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-1)
	end
end
function c101010369.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c101010369.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101010369.cfilter,1,nil,tp)
end
function c101010369.filter(c,e,tp,lv)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010369.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount()>0
		and Duel.IsExistingMatchingCard(c101010369.filter,tp,LOCATION_DECK,0,1,nil,e,tp,tc:GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010369.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010369.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg:GetFirst():GetLevel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c101010369.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101010369.rechk(c)
	return c:IsFaceup() and c.relay
end
function c101010369.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) and Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)~=0 and tg:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,2,REASON_EFFECT)
		if not Duel.IsExistingMatchingCard(c101010369.rechk,tp,LOCATION_EXTRA,0,1,nil) then
			Duel.BreakEffect()
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c101010369.sprfilter(c)
	return c:GetEquipGroup():IsExists(Card.IsAbleToGrave,1,nil) and c:IsAbleToGrave()
end
function c101010369.sprcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return Duel.IsExistingMatchingCard(c101010369.sprfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101010369.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101010369.sprfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	mg:AddCard(tc)
	local qg=tc:GetEquipGroup()
	if qg:FilterCount(Card.IsAbleToGrave,nil)>1 then
		qg=qg:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
	end
	mg:Merge(qg)
	c:SetMaterial(mg)
	Duel.SendtoGrave(qg,REASON_MATERIAL)
	Duel.SendtoGrave(tc,REASON_MATERIAL)
end
