--Yu Gi Oh! EVOLUTE Card Template: This is a Template for Level 5/Rank 3 or Below, Please do not Delete the parts where are labelled as "Do not remove".
--If You wish a non Effect Evolute Monster, just keep the Summoning function and undeletable ones.
--After reading this boring line, delete this comment or replace it with your Card's Name!
local id,ref=GIR()
function ref.start(c)
--atk
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(ref.con)
	e9:SetValue(ref.val)
	c:RegisterEffect(e9)
	--damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(101010280,1))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCountLimit(1)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(ref.con)
	e8:SetCost(ref.damcost)
	e8:SetTarget(ref.damtg)
	e8:SetOperation(ref.damop)
	c:RegisterEffect(e8)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
ref.evolute=true
ref.material1=function(mc) return mc:IsCode(101010279) and mc:IsFaceup() end
ref.material2=function(mc) return mc:IsRace(RACE_DRAGON) and mc:IsFaceup() end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
end
function ref.val(e,c)
	return (Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,RACE_DRAGON)*600)+(Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_REMOVED,0,nil,RACE_DRAGON)*500)
end
function ref.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,4,REASON_COST)
end
function ref.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsDestructable()
end
function ref.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function ref.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local neg=Effect.CreateEffect(e:GetHandler())
		neg:SetType(EFFECT_TYPE_SINGLE)
		neg:SetCode(EFFECT_DISABLE)
		neg:SetReset(RESET_EVENT+0x1fe0000)
		local dis=neg:Clone()
		dis:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(neg,true)
		tc:RegisterEffect(dis,true) 
		Duel.AdjustInstantly()
		if tc:IsDisabled() then
			local atk=tc:GetBaseAttack()
			if Duel.Destroy(tc,REASON_EFFECT)>0 then
				Duel.BreakEffect()
				Duel.Damage(1-tp,atk,REASON_EFFECT)
				Duel.Damage(tp,atk,REASON_EFFECT)
			end
		end
	end
end
